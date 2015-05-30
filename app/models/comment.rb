class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates_presence_of :body
end
