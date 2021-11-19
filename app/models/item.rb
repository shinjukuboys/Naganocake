class Item < ApplicationRecord
  belongs_to :genre
  attachment :image_id

  validates :image, presence: true
  validates :name, presence: true
  validates :explanation, presence: true
  validates :genre_id, presence: true
  # 値段設定時、半角数字のみ登録可能にするバリデーション
  validates :price, presence: true, format: {
    with: /\A[0-9]+\z/i,
  }

  def self.search(word)
    Product.where("name LIKE?", "%#{word}%")
  end
end