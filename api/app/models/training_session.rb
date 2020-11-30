class TrainingSession < ApplicationRecord
  validates :begins_at, presence: true
  belongs_to :training
  has_many :bookings
  has_many :users, through: :bookings

  def index_hash
    standard_hash
  end

  def show_hash
    h = standard_hash
    h[:description] = I18n.locale == :'zh-CN' ? training.cn_description : training.description
    h
  end

  private

  def standard_hash
    {
      id: id,
      begins_at: begins_at,
      calories: training.calories,
      duration: training.duration,
      capacity: training.capacity,
      name: I18n.locale == :'zh-CN' ? training.cn_name : training.name,
      class_type: training.class_type.kind,
      training_id: training.id
    }
  end
end
