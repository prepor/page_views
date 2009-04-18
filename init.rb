require 'page_views'

if defined?(ActiveRecord)
  PageViews::enable
end

if Object.const_defined?('ActionView')
  ActionView::Base.send :include, PageViews::Helper
end