class Training < ApplicationRecord
  validates :name, presence: true
  validates :subtitle, uniqueness: { scope: :name }
  validates :cn_name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :cn_description, presence: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :capacity, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  belongs_to :class_type
  has_many :training_sessions
  has_many :bookings, through: :training_sessions
  has_one_attached :photo
  default_scope -> { where(destroyed_at: nil) }


  def localize_description
    I18n.locale == :'zh-CN' ? cn_description : description
  end
end
