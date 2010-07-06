$LOAD_PATH.unshift(File.join( File.dirname(__FILE__), 'gentle'))

%w(base loader).each { |f| require f }

if defined? Rails
  # register gentle as template handler for rails
  if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
    ActionView::Template
  else
    ActionView::Base
  end.register_template_handler(:gntl, Gentle::RailsPlugin)
end
