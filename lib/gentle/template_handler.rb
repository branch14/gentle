module Gentle
  class TemplateHandler < ActionView::Template::Handler

    include ActionView::Template::Handlers::Compilable

    def compile(template)
      [ "Gentle::Loader.new.instance_eval do",
        template.source,
        "end" ]*"\n"
    end
    
  end
end

