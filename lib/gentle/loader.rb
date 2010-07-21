module Gentle
  class Loader < Base
    
    ERROR_TEMPLATE = File.join(File.dirname(__FILE__), %w(.. error.html))
    ERROR_COLOR = {
      SyntaxError => :red,
      NameError => :orange,
      StandardError => :yellow
    }

    # for development set :html_errors => true
    def initialize(*args)
      super()
      case args.first
        when String then @string = args.first
        when IO then @string = args.first.read
      end
      @options = args.last.is_a?(Hash) ? args.last : {}
    end
    
    def render
      load_with_binding
    rescue SyntaxError, NameError, StandardError => err
      if @options[:html_errors]
        render_error err
      else
        raise err
      end
    end

    private
    
    def load_with_binding
      eval(@string)
    end

    def render_error err
      new_template :error, ERROR_TEMPLATE
      template :error do
        at '#headline' do
          #set_attr 'style', "background-color: #{ERROR_COLOR[err.class]}"
          content err.message
        end
        at '#main' do
          content err.backtrace*"\n"
        end
      end
    end

  end
end 
