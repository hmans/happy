require 'happy/extras/permissions'

module Happy
  module Extras
    module Resources
      module ControllerExtensions
        def resource(klass, options = {}, &blk)
          run ResourceMounter, options.merge(:class => klass), &blk
        end
      end

      class ResourceMounter < Happy::Controller
        def root_url
          super(options[:plural_name])
        end

        def render_resource_template(name)
          render "#{options[:plural_name]}/#{name}.html.haml"
        end

        def resource
          options[:class]
        end

        def resource_with_permission_scope(*args)
          permissions.scoped_model(*args, options[:class])
        end

        def require_permission!(*args)
          raise "not allowed" unless permissions.can?(*args, options[:class])
        end

        def set_plural_variable(v)
          context.instance_variable_set "@#{options[:plural_name]}", v
        end

        def plural_variable
          context.instance_variable_get "@#{options[:plural_name]}"
        end

        def set_singular_variable(v)
          context.instance_variable_set "@#{options[:singular_name]}", v
        end

        def singular_variable
          context.instance_variable_get "@#{options[:singular_name]}"
        end

        def do_index
          require_permission! :index
          set_plural_variable resource_with_permission_scope(:index).all
          render_resource_template 'index'
        end

        def do_show
          require_permission! :show
          set_singular_variable resource_with_permission_scope(:show).find(params['id'])
          render_resource_template 'show'
        end

        def do_new
          require_permission! :new
          set_singular_variable resource_with_permission_scope(:new).new(params[options[:singular_name]], :as => options[:role])
          render_resource_template 'new'
        end

        def do_create
          require_permission! :create
          set_singular_variable resource_with_permission_scope(:create).new(params[options[:singular_name]], :as => options[:role])

          if singular_variable.save
            redirect! singular_variable
          else
            render_resource_template 'new'
          end
        end

        def do_edit
          require_permission! :edit
          set_singular_variable resource_with_permission_scope(:edit).find(params['id'])
          render_resource_template 'edit'
        end

        def do_update
          require_permission! :update
          set_singular_variable resource_with_permission_scope(:update).find(params['id'])
          singular_variable.assign_attributes params[options[:singular_name]], :as => options[:role]

          if singular_variable.save
            redirect! singular_variable
          else
            render_resource_template 'edit'
          end
        end

        def route
          @options = {
            :singular_name => options[:class].to_s.tableize.singularize,
            :plural_name   => options[:class].to_s.tableize.pluralize
          }.merge(@options)

          path options[:plural_name] do
            get('new') { do_new }

            path :id do
              get         { do_show }
              post        { do_update }
              get('edit') { do_edit }
            end

            post { do_create }
            get  { do_index }
          end
        end
      end
    end
  end
end

Happy::Controller.send(:include, Happy::Extras::Resources::ControllerExtensions)
