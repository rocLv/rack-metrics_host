class RequestWorker
  include Sidekiq::Worker

  def perform(id)
    @api_request = ApiRequest.find(id)
    project = Project.find(@api_request.project_id)
    object = JSON.parse(@api_request.data)
    payload = object['payload']
    name = "#{object['payload']['method']}"
    name += " #{object['payload']['path'][/[^\?]+/]}" unless object['payload']['path'].nil?
    @request = project.requests.create(
      name: name,
      controller: object['payload']['controller'],
      env: object['payload']['env'],
      action: object['payload']['action'],
      format: object['payload']['format'],
      method: object['payload']['method'],
      path: object['payload']['path'],
      status: object['payload']['status'],
      started: object['time'],
      duration: object['duration'] || 0,
      view_runtime: object['payload']['view_runtime'] || 0,
      db_runtime: object['payload']['db_runtime'] || 0,
      memory: object['payload']['memory'],
    )
    template = object['template']
    parent = build(template)
    unless template['partials'].nil?
      template['partials'].each do |partial|
        build(partial, parent)
      end
    end
    if @request.db_runtime == 0
      @request.db_runtime = @request.queries.inject(0){ |memo, r| memo += r.duration}
      @request.save
    end
    @api_request.delete
  end

  private

  def build data, parent = nil
    render = @request.renders.create!(
      layout: data['payload']['layout'],
      view: data['payload']['identifier'],
      duration: data['duration'],
      project_id: @request.project_id
    )
    unless data['queries'].nil?
      data['queries'].each do |query|
        render.queries.create!(
          name: query['name'],
          query: query['payload']['sql'],
          stack_trace: query['payload']['stacktrace'],
          duration: query['duration'],
          project_id: @request.project_id
        )
      end
    end
    render.move_to_child_of(parent) unless parent.nil? or parent == render
    render['partials'].each{|r| build(r, render)} unless render['partials'].nil?
    render
  end
end
