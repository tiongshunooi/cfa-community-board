class Issue < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, :content, :presence => true
  mount_uploader :image, IssueUploader
end
