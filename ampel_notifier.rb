require 'net/http'

class AmpelNotifier
  def initialize(project)
    @activated = false
  end
  
  def remote_server(options = {})
    @host = options[:host]
    @port = options[:port]
  end
  
  def activate!
    @activated = true
  end
  
  def activated?
    @activated
  end
  
  def build_started(build)
    Net::HTTP.get(@host, "/ampel_server/change_state?ci[project_name]=#{build.project.name}&ci[build_state]=building", @port) if activated?
  end

  def build_finished(build)
    status = build.failed? ? "broken" : "good"
    Net::HTTP.get(@host, "/ampel_server/change_state?ci[project_name]=#{build.project.name}&ci[build_state]=#{status}", @port) if activated?
  end

  def build_fixed(build, previous_build)
    Net::HTTP.get(@host, "/ampel_server/change_state?ci[project_name]=#{build.project.name}&ci[build_state]=good", @port) if activated?
  end

  def build_broken(build, previous_build)
    Net::HTTP.get(@host, "/ampel_server/change_state?ci[project_name]=#{build.project.name}&ci[build_state]=broken", @port) if activated?
  end
  
end

Project.plugin :ampel_notifier