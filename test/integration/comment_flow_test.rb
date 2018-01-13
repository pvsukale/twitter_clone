require 'test_helper'

class CommentFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
  end

  test "comment interface" do
    log_in_as(@user)
    get root_path
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: ""  } ,micropost: @micropost.id}
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "Biswa bahut hi mast aadmi hai"
    assert_difference 'Comment.count', 1 do
      post comments_path, params: { comment: { content: content }, micropost: @micropost.id }
    end
    assert_redirected_to micropost_path(@micropost)
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_comment = @user.comments.last
    assert_difference 'Comment.count', -1 do
      delete comment_path(first_comment)
    end
    # Visit different user (no delete links)
    get micropost_path(microposts(:van))
    assert_select 'a', text: 'delete', count: 0
  end
end
