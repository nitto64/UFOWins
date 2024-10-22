class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  has_one_attached :thumbnail

  # バリデーション
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
end
