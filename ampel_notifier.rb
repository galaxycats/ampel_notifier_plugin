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
      self.activated? and send("_#{meth}", *args)
    else
      super
    end
  end
  
  private
  
    def _build_started(build)
      Net::HTTP.get @host, "/ampel_server/change_state?ci[name]=#{build.project.name}&ci[build_state]=building", @port
    end
  
    def _build_finished(build)
      Net::HTTP.get @host, "/ampel_server/change_state?ci[name]=#{build.project.name}&ci[build_state]=good", @port
    end
  
    def _build_fixed(build, previous_build)
      Net::HTTP.get @host, "/ampel_server/change_state?ci[name]=#{build.project.name}&ci[build_state]=good", @port
    end
  
    def _build_broken(build, previous_build)
      Net::HTTP.get @host, "/ampel_server/change_state?ci[name]=#{build.project.name}&ci[build_state]=broken", @port
    end
  
end

Project.plugin :ampel_notifier