module PageViews
  module Controller
    def page_views_increment(object)
      cookies[:page_views] = object.page_views_add(cookies[:page_views])
    end
  end
end