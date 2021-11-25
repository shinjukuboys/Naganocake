class Item < ApplicationRecord
  belongs_to :genre
  has_many :cart_items
  has_many :order_details, dependent: :destroy
  attachment :image

  validates :genre_id, :name, presence: true
	validates :introduction, length: {maximum: 200}
	validates :price, numericality: { only_integer: true}

  def self.search(word)
    Product.where("name LIKE?", "%#{word}%")
  end
  
  def taxin_price
    price * 1.1
  end
end