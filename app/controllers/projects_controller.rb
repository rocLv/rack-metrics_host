class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_resource only: [:create]
  def metrics
    @project = current_user.projects.find(params[:project_id])
    @filter = Filter.new(params[:filter])
    respond_to do |format|
      format.html {}
      format.json{
        data = {}
        diff = ((@filter.to_time - @filter.from_time) / 3600).round.abs
        step = diff.minutes

        points = points(@filter.from_time, @filter.to_time, step)
        format = (diff <= 24) ? :time : :short
        format = :short
        @rpm = {}
        result = @project.requests.where(started: @filter.from_time...@filter.to_time, env: @filter.env).group_by(step).count
        result.each do |i, e|
          @rpm[Time.at(i*step)] = e
        end
        @rpm = Hash[@rpm.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}.sort]
        @rpm = points.merge(@rpm)
        @rpm = Hash[@rpm.inject({}){|memo,(k,v)| memo[k] = v; memo}.sort]

        @response_time = {}
        values = []
        @project.requests.where(started: @filter.from_time...@filter.to_time, env: @filter.env).group_by(step).average(:duration).each do |i, e|
          @response_time[Time.at(i*step)] = e
        end
        @response_time = Hash[@response_time.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}.sort]
        @response_time = points.merge(@response_time)
        @response_time = Hash[@response_time.inject({}){|memo,(k,v)| memo[k] = v.to_f.round; memo}.sort]

        @response_time_2 = {}
        h = {}
        @project.requests.select("percentile_95th(duration) as duration, round(extract(epoch from \"started\"::timestamptz AT TIME ZONE 'Etc/UTC')/#{step}) AS timestamp").where(started: @filter.from_time...@filter.to_time, env: @filter.env).group_by(step).map{|r| h[r.timestamp] = r.duration }
        h.each do |i, e|
          @response_time_2[Time.at(i*step)] = e
        end
        @response_time_2 = Hash[@response_time_2.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}.sort]
        @response_time_2 = points.merge(@response_time_2)
        @response_time_2 = Hash[@response_time_2.inject({}){|memo,(k,v)| memo[k] = v.to_f.round; memo}.sort]

        @memory = {}
        @project.requests.where(started: @filter.from_time...@filter.to_time, env: @filter.env).group_by(step).average(:memory).each do |i, e|
          @memory[Time.at(i*step)] = e
        end
        @memory = @memory.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}
        @memory = points.merge(@memory)
        @memory = Hash[@memory.inject({}){|memo,(k,v)| memo[k] = v.to_f.round; memo}.sort]

        data[:response_time] = [{
          key: 'Response time',
          color: '#75BE23',
          values: @response_time.map{|i, v| {x: i.to_i.in_milliseconds, y: v }},
          area: true
        }]

        data[:response_time_2] = [{
          key: 'Response time 2',
          color: '#75BE23',
          values: @response_time_2.map{|i, v| {x: i.to_i.in_milliseconds, y: v }},
          area: true
        }]

        data[:rpm] = [{
          key: 'Requests per minute',
          color: '#75BE23',
          values: @rpm.map{|i, v| {x: i.to_i.in_milliseconds, y: v}},
          area: true
        }]

        data[:memory] = [{
          key: 'Memory usage(MB)',
          color: '#75BE23',
          values: @memory.map{|i, v| {x: i.to_i.in_milliseconds, y: v}},
          area: true
        }]
        render json: data
      }
    end
  end

  def page_load_last_100
    @requests = @project.requests.order('created_at desc').limit(100).all.reverse
    data = @requests.map do |request|
      [
        request.started.to_s(:short),
        request.db_runtime.round(2),
        request.duration.round(2),
        render_to_string(partial: 'tooltip', locals: {request: request}, formats: [:html])
      ]
    end
    render json: data
  end

  def rpm
    @rpm = @project.requests.where(started: 30.minutes.ago...Time.now).group_by_minute(:started).count()
    @rpm = @rpm.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}
    @rpm = points.merge(@rpm)
    @rpm = Hash[@rpm.inject({}){|memo,(k,v)| memo[k.change(sec: '00').to_s(:time)] = v; memo}.sort]
    data = [["Time", "RPM"]]
    data = data.concat(@rpm.to_a)
    render json: data
  end

  def memory
    @memory = @project.requests.where(started: 30.minutes.ago...Time.now).group_by_minute(:started).average(:memory)
    @memory = @memory.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}
    @memory = points.merge(@memory)
    @memory = Hash[@memory.inject({}){|memo,(k,v)| memo[k.change(sec: '00').to_s(:time)] = v; memo}.sort]
    data = [["Time", "Memory"]]
    data = data.concat(@memory.to_a)
    render json: data
  end

  def page_load
    @response_time = @project.requests.where(started: 30.minutes.ago...Time.now).group_by_minute(:started).average(:duration)
    @response_time = @response_time.inject({}){|memo,(k,v)| memo[k.change(sec: '00')] = v; memo}
    @response_time = points.merge(@response_time)
    @response_time = Hash[@response_time.inject({}){|memo,(k,v)| memo[k.change(sec: '00').to_s(:time)] = v; memo}.sort]
    data = [["Time", "Average response time"]]
    data = data.concat(@response_time.to_a)
    render json: data
  end
  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = current_user.projects.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.owned_projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.owned_projects.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end

    def points(from, to, step)
      points = {}
      while to > from do
        points[from] = 0
        from += step
      end
      points
    end

  def can_view_metrics?
    current_user == @project.owner || @project.users.include?(current_user)
  end
end
