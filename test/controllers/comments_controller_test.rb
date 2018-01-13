require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
 

  def setup
    
  end

  test "should redirect create post when not logged in" do
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    @comment = comments(:one)
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    @micropost = microposts(:wonder)
    @comment = comments(:two)
    
    log_in_as(users(:michael))
    
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to root_url
  end
end
