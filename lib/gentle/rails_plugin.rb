module Gentle
  class RailsPlugin

    def compile(template)
      if template.respond_to?(:source)
        options[:filename] = template.respond_to?(:identifier) ? template.identifier : template.filename
        source = template.source
      else
        source = template
      end
      options = production? ? {} : { :html_errors => true }
      Gentle::Loader.new(File.new(source, 'r'), options).compile
    end

    private

    def production?
      'production' == (ENV['RAILS_ENV'] || Rails.env)
    end

  end
end

