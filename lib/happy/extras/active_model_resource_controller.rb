require 'happy/extras/resource_controller'

module Happy
  module Extras

    class ActiveModelResourceController < Happy::Extras::ResourceController
      def root_url
        super(settings[:plural_name])
      end

      def render_resource_template(name)
        render "#{settings[:plural_name]}/#{name}.html.haml"
      end

      def resource
        settings[:class]
      end

      def resource_with_permission_scope(*args)
        permissions.scoped_model(*args, settings[:class])
      end

      def require_permission!(*args)
        raise "not allowed" unless permissions.can?(*args, settings[:class])
      end

      def set_plural_variable(v)
        instance_variable_set "@#{settings[:plural_name]}", v
      end

      def plural_variable
        instance_variable_get "@#{settings[:plural_name]}"
      end

      def set_singular_variable(v)
        instance_variable_set "@#{settings[:singular_name]}", v
      end

      def singular_variable
        instance_variable_get "@#{settings[:singular_name]}"
      end

      def index
        require_permission! :index
        set_plural_variable resource_with_permission_scope(:index).all
        render_resource_template 'index'
      end

      def show
        require_permission! :show
        set_singular_variable resource_with_permission_scope(:show).find(params['id'])
        render_resource_template 'show'
      end

      def new
        require_permission! :new
        set_singular_variable resource_with_permission_scope(:new).new(params[settings[:singular_name]], :as => settings[:role])
        render_resource_template 'new'
      end

      def create
        require_permission! :create
        set_singular_variable resource_with_permission_scope(:create).new(params[settings[:singular_name]], :as => settings[:role])

        if singular_variable.save
          redirect! singular_variable
        else
          render_resource_template 'new'
        end
      end

      def edit
        require_permission! :edit
        set_singular_variable resource_with_permission_scope(:edit).find(params['id'])
        render_resource_template 'edit'
      end

      def update
        require_permission! :update
        set_singular_variable resource_with_permission_scope(:update).find(params['id'])
        singular_variable.assign_attributes params[settings[:singular_name]], :as => settings[:role]

        if singular_variable.save
          redirect! singular_variable
        else
          render_resource_template 'edit'
        end
      end

      def route
        settings[:singular_name] ||= settings[:class].to_s.tableize.singularize
        settings[:plural_name]   ||= settings[:class].to_s.tableize.pluralize

        super
      end
    end

  end
end
