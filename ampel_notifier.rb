require 'net/http'

class AmpelNotifier
  def initialize(project)
    @host = "ampelserver.yourproject.de"
    @port = 80
  end
  
  def server(options = {})
    @host = options[:host]
    @port = options[:port]
  end
  
  def build_started(build)
    Net::HTTP.get_print @host, '/ampel_server/index?actions[yellow]=On', @port
  end
  
  def build_finished(build)
    Net::HTTP.get_print @host, '/ampel_server/index?actions[yellow]=Off&actions[green]=On', @port
  end
  
  def build_fixed(build)
    Net::HTTP.get_print @host, '/ampel_server/index?actions[yellow]=Off&actions[green]=On', @port
  end
  
  def build_broken(error)
    Net::HTTP.get_print @host, '/ampel_server/index?actions[yellow]=Off&actions[green]=Off&actions[red]=On&actions[signal]=23', @port
  end
  
  def build_loop_failed(error)
    Net::HTTP.get_print @host, '/ampel_server/index?actions[yellow]=Off&actions[green]=Off&actions[red]=On', @port
  end
  
end

Project.plugin :ampel_notifier