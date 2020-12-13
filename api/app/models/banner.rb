class Banner < ApplicationRecord
  has_one_attached :photo

  def standard_hash
    {
      id: id,
      url: photo.service_url
    }
  end
end
