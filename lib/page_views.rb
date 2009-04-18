class PageViewsError < StandardError; end
# class PageViews
module PageViews
  
  def self.enable
    ActiveRecord::Base.class_eval { extend PageViews::ClassMethods }
  end
  module ClassMethods
    DEFAULT_PAGE_VIEWS_OPTIONS = {:buffer_size => 100, :with_buffer => true, :days => 2}
    
    def with_page_views(options = {})
      options = DEFAULT_PAGE_VIEWS_OPTIONS.merge(options)
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
    def page_views_add(cookies)
      cookies = Marshal.load(cookies) if cookies.is_a?(String)
      unless already_view_page?(cookies)
        page_views_increment
        if cookies.nil? || !cookies.is_a?(Hash)
          cookies = {}
        end
        cookies[page_views_cookie_key] ||= []
        cookies[page_views_cookie_key] << page_views_id
        cookies = page_views_clear_cookies(cookies)
      end
      Marshal.dump(cookies)
    end
    
    def page_views_clear_cookies(cookies)
      cookies.delete_if {|k, v| k < page_views_options[:days].ago.strftime('%d%m')}
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
    
    def page_views_field
      :page_views_counter
    end
    
    def page_views_field_value
      self.send(page_views_field.to_sym)
    end
    def page_views_field_set(val)
      self.send(page_views_field.to_sym,  val)
    end
    
    def page_views_id
      self.id
    end
  end
  
end