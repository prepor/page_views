# don't use this

module PageViews
  module Metal
    def call(env)
      if env["PATH_INFO"] =~ /^\/page_views/
        @request = Rack::Request.new(env)    
        model_class = params[:model].constantize    
        raise PageViewsError unless model_class.with_page_views?
        object = model_class.find(params[:id])
        object.page_views_add(@request.cookies[:page_views])
        [200, {"Content-Type" => "image/png"}, [""]]
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
      end
    end
    def params
      @request.params
    end
  end
end