module Happy
  class Request < Rack::Request
    module DateParameterConverter
      class << self
        def convert!(params)
          params.each do |k, v|
            if looks_like_a_date?(v)
              params[k] = convert_to_date(v)
            elsif v.is_a? Hash
              convert!(v)
            end
          end
        end

        def looks_like_a_date?(v)
          v.is_a?(Hash) && v.has_key?('year') && v.has_key?('month') && v.has_key?('day')
        end

        def convert_to_date(v)
          DateTime.new(v['year'].to_i, v['month'].to_i, v['day'].to_i, v['hour'].to_i, v['minute'].to_i, v['second'].to_i)
        end
      end
    end
  end
end
