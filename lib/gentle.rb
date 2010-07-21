puts "=== LOADING GENTLE ==="

%w(base loader).each do |f|
  require File.join(File.dirname(__FILE__), 'gentle', f)
end

if defined? Rails
  puts "=== GENTLE DETECTED RAILS ==="
  file = File.join(File.dirname(__FILE__), %w(gentle template_handler))
  puts "=== REQUIRE #{file} ==="
  require file
  # register gentle as template handler for rails
  if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
    ActionView::Template
  else
    ActionView::Base
  end.register_template_handler(:gntl, Gentle::TemplateHandler)
  puts "=== GENTLE REGISTERED AS RAILS TEMPLATE HANDLER ==="
end
