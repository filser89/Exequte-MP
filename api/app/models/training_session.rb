class TrainingSession < ApplicationRecord
  validates :begins_at, presence: true
  belongs_to :training
  has_many :bookings
  has_many :users, through: :bookings



  def standard_hash
    {
      id: id,
      begins_at: begins_at,
      calories: training.calories,
      duration: training.duration,
      capacity: training.capacity,
      name: localize_name,
      class_type: training.class_type.kind,
      bookable: can_book?

    }
  end

  def localize_name
    I18n.locale == :'zh-CN' ? training.cn_name : training.name
  end

  def localize_description
    I18n.locale == :'zh-CN' ? training.cn_description : training.description
  end

  def can_book?
    training.capacity > bookings.where(cancelled: false).count
  end
end
