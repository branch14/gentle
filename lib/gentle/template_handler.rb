if defined?(ActionView::Template::Handler) # Rails >=3
  PARENT_CLASS = ActionView::Template::Handler
  INCLUDE_MODULE = ActionView::Template::Handlers::Compilable
else # Rails <3
  PARENT_CLASS = ActionView::TemplateHandler
  INCLUDE_MODULE = ActionView::TemplateHandlers::Compilable
end

module Gentle
  class TemplateHandler < PARENT_CLASS
    include INCLUDE_MODULE
    def compile(template)
      [ "Gentle::Loader.new.instance_eval do",
        template.source,
        "end" ]*"\n"
    end
  end
end

# FIXME include Rails standard helper here
#Gentle::Loader.class_eval do
#  include ActionView::Helpers::TranslationHelper
#  include ActionController::UrlWriter
#end
