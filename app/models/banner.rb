class Banner < ApplicationRecord
  has_one_attached :photo

  def standard_hash
    h = {
      id: id,
    }
    h[:url] =  photo.service_url if photo.attached?
    h
  end
end
