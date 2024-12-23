class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  has_many :bookmarks, dependent: :destroy

  # 画像のアップロード
  has_one_attached :thumbnail, dependent: :destroy
  has_many_attached :main_images, dependent: :destroy

  # バリデーション
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :thumbnail, attachment: { content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 15.megabytes, purge: true }
  validates :main_images, attachment: { content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 15.megabytes, purge: true }

  # 検索の使用できる属性の指定
  def self.ransackable_attributes(auth_object = nil)
    [ "title", "body", "item_name", "created_at", "updated_at", "user_id" ]
  end

  # 商品名のデフォルトの表示メソッド
  def item_name_or_default
    item_name.presence || "未設定"
  end
end
