class PageViewsGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template(
        'add_page_views.rb', 'db/migrate', :migration_file_name => "add_page_views_to_#{file_name}"
      )      

    end
  end
end