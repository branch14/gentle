require 'rubygems'
require 'nokogiri'

# If not explicilty stated differently, the following applies to every
# transformer: +data+ may be passed as value or as block. If a value
# is given it's taken as +data+, if no value is given the block will
# be called and the result of the block is taken as +data+. +data+ can
# be one of:
#
# - Nokogiri::XML::Node
# - Nokogiri::XML::DocumentFragment
# - Nokogiri::XML::NodeSet
# - String (which will be escaped) [this might change in future versions]
#
# You can pass markup by wrapping it with the markup helper.
#
#  +markup "<blink>hello, world</blink>"+
#
# This is also useful, when working with Rails' render :partial
#
#  +markup(render(:partial => 'some-partial', :collection => @worlds))+
#
module Gentle
  class Base
    
    def initialize
      @templates = {}
    end

    def new_template name, path
      @templates[name.to_sym] ||= load_template(path)
    end

    def template name
      @document = @templates[name.to_sym]
      yield if block_given?
      @document
    end
    
    #------------------------------------------------------------
    # selector

    # at '#some-css-path'
    # at :css => '#some-css-path'
    # at :xpath => '//some/xpath/path'
    def at *args
      options = args.first || {}
      options = {:css => options} if options.is_a?(String)
      unless options.has_key?(:css) || options.has_key?(:xpath)
        raise ArgumentError.new 'either :css or :xpath must be specified' 
      end
      stack = @node
      if options.has_key?(:css)
        @node = @document.at_css options[:css]
        raise "CSS3 Selector '#{options[:css]}' did not match anything" unless @node
      elsif options.has_key?(:xpath)
        @node = @document.at_xpath options[:xpath]
        raise "XPath '#{options[:xpath]}' did not match anything" unless @node
      end
      yield if block_given?
      @node = stack
    end
    
    #------------------------------------------------------------
    # helpers

    # returns a new Nokogiri::XML::Node
    def node *args
      Nokogiri::XML::Node.new(*(args << @document))
    end

    # returns a new Nokogiri::XML::Text
    def text a_string
      Nokogiri::XML::Text.new(a_string, @document)
    end

    # parses the markup and returns a new Nokogiri::XML::DocumentFragment
    #
    # FIXME doesn't work as advertised
    def markup a_string_with_markup=nil
      a_string_with_markup ||= yield
      Nokogiri::XML::DocumentFragment.parse(a_string_with_markup)
    end

    #------------------------------------------------------------
    # transformators

    def content data=nil # enlive
      @node.content = (data || yield)
    end

    def wrap data=nil # enlive, jquery
      data ||= yield
      new_node = data.is_a?(String) ? node(data) : data
      new_node.parent = @node.parent
      new_node.add_child(@node)
    end

    def unwrap # enlive, jquery
      @node.children.each { |child| @node.parent.add_child(child) } 
      @node.remove
    end

    def set_attr attr, data=nil # enlive
      @node[attr] = (data || yield)
    end

    def remove_attr *attrs # enlive, jquery
      attrs.each { |a| @node.remove_attribute(a.to_s) }
    end

    def add_class data=nil # enlive, jquery
      classes = (@node['class']||'').split(' ')
      classes << (data || yield)
      @node['class'] = classes.flatten.uniq.join(' ')
    end

    def remove_class data=nil # enlive, jquery
      data ||= yield
      data = [data] unless data.is_a?(Array)
      classes = (@node['class']||'').split(' ')
      data.each { |klass| classes.delete(klass) }
      @node['class'] = classes.join(' ')
      @node.remove_attribute('class') if @node['class'].empty?
    end

    def append data=nil # enlive, jquery
      data ||= yield
      new_node = data.is_a?(String) ? text(data) : data 
      @node.children.last.add_next_sibling(new_node)
    end

    def prepend data=nil # enlive, jquery
      data ||= yield
      new_node = data.is_a?(String) ? text(data) : data
      @node.children.first.add_previous_sibling(new_node)
    end

    def after data=nil # enlive, jquery
      data ||= yield
      new_node = data.is_a?(String) ? text(data) : data
      @node.add_next_sibling(new_node)
    end

    def before data=nil # enlive, jquery
      data ||= yield
      new_node = data.is_a?(String) ? text(data) : data
      @node.add_previous_sibling(new_node)
    end

    def substitute data=nil # enlive
      data ||= yield
      new_node = data.is_a?(String) ? text(data) : data
      @node.replace(new_node)
    end
    alias_method :replace_with, :substitute # jquery

    def empty # jquery
      @node.children.each { |child| child.remove }
    end

    def remove # jquery
      substitute ''
    end

    # def html_content
    # end
    #
    # def move
    # end
    # 
    # def do!
    # end
    # 
    # def clone_for
    # end

    #------------------------------------------------------------
    
    protected
    
    # unknown method calls default to Nokogiri::XML::Node
    def method_missing(method_name, *args)
      @node.send(method_name, args)
    end
    
    # reads & parses the file given by +path+ and returns a new Nokogiri::HTML:Document
    def load_template(path)
      Nokogiri::HTML(open(path))
    end

  end
end 
