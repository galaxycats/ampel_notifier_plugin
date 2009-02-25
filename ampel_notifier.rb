require 'net/http'

class AmpelNotifier
  def initialize(project)
    @host = "ampelserver.yourproject.de"
    @port = 80
  end
  
  def remote_server(options = {})
    @host = options[:host]
    @port = options[:port]
  end
  
  def build_started(build)
    Net::HTTP.get @host, '/ampel_server/index?actions[yellow]=On', @port
  end
  
  def build_finished(build)
    Net::HTTP.get @host, '/ampel_server/index?actions[yellow]=Off', @port
  end
  
  def build_fixed(build, previous_build)
    Net::HTTP.get @host, '/ampel_server/index?actions[red]=Off&actions[green]=On', @port
  end
  
  def build_broken(build, previous_build)
    Net::HTTP.get @host, '/ampel_server/index?actions[green]=Off&actions[red]=On&actions[signal]=23', @port
  end
  
end

Project.plugin :ampel_notifier