require 'test/test_helper'

class UnitTest < Test::Unit::TestCase
  context "A Post without buffer" do
    setup do
      rebuild_models
      @post = Post.create :name => 'first'
    end

    should "has counter == 1" do
      assert_equal @post.page_views_counter, 0
    end
    
    context "after view" do
      setup do        
        @cookies = @post.page_views_add(nil)
      end

      should "has counter == 1" do
        assert_equal @post.page_views_counter, 1
      end
      
      should "cookies be right" do
        assert_equal({'post' => {Time.now.strftime('%d%m') => [@post.id]}}, Marshal.load(@cookies))
      end
      
      context "and second view" do
        setup do
          @cookies2 = @post.page_views_add(@cookies)
        end

        should "has counter == 1" do
          assert_equal @post.page_views_counter, 1
        end
      end      
      # context "and second view after 3 days" do
      #   setup do
      #     time = 3.days.since
      #     Time.stubs(:now).returns(time)
      # 
      #     @cookies2 = @post.page_views_add(@cookies)
      #   end
      # 
      #   should "has counter == 2" do
      #     assert_equal 2, @post.page_views_counter
      #   end
      # end
      
      
    end
    
  end
  
end