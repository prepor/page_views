About
====

Little pluging, that make one sql-update per 100 (by default, you can make 1000 or 10) for each page request. Its use cookies to store information about user's views and Rails.cache for buffer.

Usage
====

Install

	./script/plugin install git://github.com/preprocessor/page_views.git

Create migration

	./script/generate page_views Post

Model:

	class Post < ActiveRecord::Base
	  with_page_views
	end

Controller:

	include PageViews::Controller

	bafore_filter :increment_page_views, :only => [:show]

	def increment_page_views
	  page_views_increment @post #load @post before
	end

View:
        
       @post.page_views


Options
====

	with_page_views :buffer_size => 1000, :days => 3, :model_name => 'post'

buffer_size — how often to write down the value buffer in the database

days — how many days to store information about pages user visit in the cookie (by default 2 days)

	with_page_views :with_buffer => false

with_buffer — not advised to switch off, even if you do not have memcache rails used by default MemoryStore. 

model_name — custom name of model for keys in cookies and cache

ToDo
====

tests :)