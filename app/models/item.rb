class Item < ApplicationRecord
  belongs_to :genre
  attachment :image_id
end
