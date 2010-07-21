%w(base loader).each do |f|
  require File.join(File.dirname(__FILE__), 'gentle', f)
end

if defined? Rails
  require File.join(File.dirname(__FILE__), %w(gentle template_handler))
  # register gentle as template handler for rails
  if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
    ActionView::Template
  else
    ActionView::Base
  end.register_template_handler(:gntl, Gentle::TemplateHandler)
end
