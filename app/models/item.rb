class Item < ApplicationRecord
  belongs_to :genre
  attachment :image_id
  
  validates :genre_id, :name, :price, presence: true
	validates :explanation, length: {maximum: 200}
	validates :price, numericality: { only_integer: true}

  def self.search(word)
    Product.where("name LIKE?", "%#{word}%")
  end
end