class PageViewsError < StandardError; end
# class PageViews
module PageViews
  require 'page_views/controller'
  require 'page_views/buffers/cache'
  require 'page_views/buffers/none'
  def self.enable
    ActiveRecord::Base.class_eval { extend PageViews::ClassMethods }
  end
  module ClassMethods
    DEFAULT_PAGE_VIEWS_OPTIONS = {:buffer_size => 100, :with_buffer => true, :days => 2}
    
    def with_page_views(options = {})
      options = DEFAULT_PAGE_VIEWS_OPTIONS.merge(options)
      unless options[:model_name]
        options[:model_name] = self.name.underscore
      end
      write_inheritable_attribute :page_views_options, options
      class_inheritable_reader :page_views_options
      include InstanceMethods
      
      if options[:with_buffer]
        include Buffers::Cache
      else
        include Buffers::None
      end
    end    
  end
  
  module InstanceMethods
    
    def page_views_field
      :page_views_counter
    end
    
    def page_views_id
      self.id
    end    
    
    def page_views_add(cookies)
      
      cookies = (cookies.is_a?(String) && res = Marshal.load(cookies)) ? res : {}
      
      cookies_for_model = cookies[page_views_options[:model_name]] ? cookies[page_views_options[:model_name]] : {}
      unless already_view_page?(cookies_for_model)
        page_views_increment
        if cookies_for_model.nil? || !cookies_for_model.is_a?(Hash)
          cookies_for_model = {}
        end
        cookies_for_model[page_views_cookie_key] ||= []
        cookies_for_model[page_views_cookie_key] << page_views_id
        cookies_for_model = page_views_clear_cookies(cookies_for_model)
        cookies[page_views_options[:model_name]] = cookies_for_model
      end
      Marshal.dump(cookies)
    end
    
    def page_views_clear_cookies(cookies)
      require 'ruby-debug'
      debugger
      cookies.delete_if {|k, v| k < page_views_options[:days].days.ago.strftime('%d%m')}
    end
        
    def already_view_page?(cookies)
      if cookies && cookies[page_views_cookie_key] && cookies[page_views_cookie_key].include?(page_views_id)
        true
      else
        false
      end
    end
    
    def page_views_cookie_key
      @page_views_cookie_key ||= Time.now.strftime('%d%m')
    end
    
    def page_views_field_value
      self.send(page_views_field.to_sym)
    end
    def page_views_field_set(val)
      self.send(page_views_field.to_sym,  val)
    end
    

  end
  
end