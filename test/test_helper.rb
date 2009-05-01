require 'rubygems'
require 'test/unit'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'mocha'
require 'mocha'
require 'active_record'
require 'active_support'
require 'action_controller'

require 'page_views'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])



def rebuild_models(options = {})
  ActiveRecord::Base.connection.create_table :posts, :force => true do |table|
    table.column :name, :string
    table.column :page_views_counter, :integer, :default => 0
  end
  rebuild_classes(options)
end

def rebuild_classes(options = {})
  PageViews::enable
  end_options = {:with_buffer => false}.merge(options)
  Object.send(:remove_const, "Post") rescue nil
  Object.const_set("Post", Class.new(ActiveRecord::Base))
  Post.class_eval do
    with_page_views(end_options)
  end
  # #{end_options}"

end
