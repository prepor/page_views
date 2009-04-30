module PageViews::Buffers
  module Cache
    def page_views      
      page_views_field_value + page_views_from_buffer
    end
    private
    def page_views_increment
      val = (Rails.cache.read(page_views_cache_key) || 0) + 1
      Rails.cache.write(page_views_cache_key, val)
      if val >= page_views_options[:buffer_size]
        self.increment! page_views_field, val
        Rails.cache.write page_views_cache_key, 0
      end
    end
    
    def page_views_from_buffer
      Rails.cache.read(page_views_cache_key) || 0
    end
    
    def page_views_cache_key
      "#{page_views_options[:model_name]}_page_views_#{page_views_id}"
    end
  end
end