require 'test_helper'

class CommentTest < ActiveSupport::TestCase
 
  test "comment should have content" do 
    @comment = Comment.new(content: "")
    assert_not @comment.valid?
  end

  test "comment should not have more than 140 characters" do
    @comment = Comment.new( content: "a" *150)
    assert_not @comment.valid?
  end

end
