module PageViews::Buffers
  module None
    def page_views      
      page_views_field_value
    end
    private
    def page_views_increment
      self.increment! page_views_field
    end
  end
end