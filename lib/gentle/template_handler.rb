puts "=== READING Gentle::TemplateHandler ==="

module Gentle
  class TemplateHandler < ActionView::Template::Handler

    include ActionView::Template::Handlers::Compilable

    def compile(template)
      [ "Gentle::Loader.new.instance_eval do",
        template.source,
        "end" ]*"\n"
    end
    
    # def initialize(view)
    #   puts "=== INSTANTIATE Gentle::TemplateHandler ==="
    #   @view = view
    # end
    # 
    # def render(template, locals = {})
    #   puts "=== CALLED Gentle::TemplateHandler#render ==="
    #   options = {}
    #   prepare_view(locals)
    # 
    #   if template.respond_to?(:source)
    #     options[:filename] = template.respond_to?(:identifier) ? template.identifier : template.filename
    #     source = template.source
    #   else
    #     source = template
    #   end
    #   # options[:html_errors] = true unless production?
    # 
    #   @view.instance_eval do 
    #     Gentle::Loader.new(source, options).render.to_xhtml
    #   end
    # end
    # 
    # private
    # 
    # def production?
    #   'production' == (ENV['RAILS_ENV'] || Rails.env)
    # end
    # 
    # def prepare_view(locals)
    #   @view.instance_eval do
    #     # inject assigns into instance variables
    #     assigns.each do |key, value|
    #       instance_variable_set "@#{key}", value
    #     end
    # 
    #     # inject local assigns into reader methods
    #     locals.each do |key, value|
    #       class << self; self; end.send(:define_method, key) { val }
    #     end
    #   end
    # end

  end
end

