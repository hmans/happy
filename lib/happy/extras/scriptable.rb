require 'happy/extras/permissions'

module Happy
  module Extras
    class Scriptable < Happy::Controller
      def route
        run_script 'permissions.rb'
        run_script 'route.rb'
      end

      def run_script(name)
        instance_exec &get_proc_for_script(name)
      end

      def get_proc_for_script(name)
        if reload_script?(name)
          procs[name] = eval "lambda { %s }" % load_script(name)
        end
        procs[name]
      end

      def reload_script?(name)
        !procs[name] || Happy.env.development?
      end

      def load_script(name)
        file_name = File.expand_path(File.join(options[:directory], name))
        File.read(file_name)
      end

      def procs
        @procs ||= {}
      end
    end
  end
end
