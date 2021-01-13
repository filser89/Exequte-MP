class Banner < ApplicationRecord
  has_one_attached :photo
  default_scope -> { where(destroyed_at: nil) }


  def standard_hash
    h = {
      id: id,
    }
    h[:url] =  photo.service_url if photo.attached?
    h
  end
end
