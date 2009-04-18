class AddPageViewsTo<%= class_name %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :page_views_counter, :integer, :default => 0
    add_index :<%= table_name %>, :page_views_counter
  end

  def self.down
    remove_index :<%= table_name %>, :page_views_counter
    remove_column :<%= table_name %>, :page_views_counter
  end
end
