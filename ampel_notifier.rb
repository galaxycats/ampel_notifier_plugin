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

  def method_missing(meth, *args, &blk)
    if meth.to_s =~ /build_\w+/
      activated? and send("_#{meth}", *args)
    else
      super
    end
  end
  
  private
  
    def _build_started(build)
      Net::HTTP.get @host, '/ampel_server/index?actions[yellow]=On', @port
    end
  
    def _build_finished(build)
      Net::HTTP.get @host, '/ampel_server/index?actions[yellow]=Off', @port
    end
  
    def _build_fixed(build, previous_build)
      Net::HTTP.get @host, '/ampel_server/index?actions[red]=Off&actions[green]=On', @port
    end
  
    def _build_broken(build, previous_build)
      Net::HTTP.get @host, '/ampel_server/index?actions[green]=Off&actions[red]=On&actions[signal]=23', @port
    end
  
end

Project.plugin :ampel_notifier