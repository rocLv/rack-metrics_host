class RequestsController < ApplicationController
  before_filter :find_project

  def index
    respond_to do |format|
      format.html do
        @q = @project.requests.search(params[:q])
        result = @q.result(distinct: true)
        @count = result.count
        @requests = result.order('started desc').page(params[:page])
      end
      format.json do
        @requests = @project.requests.where("name like ?", "%#{params[:q]}%").distinct(:name).limit(20).load
      end
    end
  end

  def dashboard
    requests = Request.find_by_sql(["select * from (select DISTINCT ON (name) * from requests where project_id = ?) as path where started > ? order by duration desc limit 10", @project.id, 7.days.ago])
    response_time = {
      key: "Response time",
      color: "#75BE23",
      values: requests.map{|p| {label: p.name, value: p.duration - p.db_runtime, url: project_request_path(@project, p)}}
    }
    db_runtime = {
      key: "DB runtime",
      color: "#E7D057",
      values: requests.map{|p| {label: p.name, value: p.db_runtime, url: project_request_path(@project, p)}}
    }
    @slowest = [db_runtime, response_time]
    requests = @project.requests.where('started > ?', 7.days.ago).group(:name).limit(10).order('count_all desc').count()
    @highest_throughput = [
      {
      key: "Throughput",
      color: "#75BE23",
      values: requests.map{|i, k| {label: i, value: k}}
      }
    ]

    respond_to do |format|
      format.html {}
      format.json do
        render json: {slowest: @slowest, highest_throughput: @highest_throughput}
      end
    end
  end

  def busiest_paths
    busiest_paths = Kaminari.paginate_array(@project.requests.select('percentile_95th(duration) as duration, count(*) as count_all, name').where('started > ?', 7.days.ago).group(:name).order('count_all desc, duration desc').sort_by{|h| h.duration}.reverse).page(params[:page])
    busiest_paths2 = Kaminari.paginate_array(@project.requests.select('avg(duration) as duration, count(*) as count_all, name').where('started > ?', 7.days.ago).group(:name).order('count_all desc').sort_by{|h| h.duration}.reverse).page(params[:page])
    @data = [{
      key: "Response time",
      color: "#75BE23",
      values: busiest_paths.map{|v| {label: v.name, value: v.duration}},
    }]
    @data2 = [{
      key: "Response time",
      color: "#75BE23",
      values: busiest_paths2.map{|v| {label: v.name, value: v.duration}},
    }]
  end

  def show
    @request = @project.requests.find(params[:id])
    if request.xhr?
      render layout: false
    else
      render
    end
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  end

  def can_view_metrics?
    current_user == @project.owner || @project.users.include?(current_user)
  end
end
