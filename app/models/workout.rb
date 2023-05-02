
class Workout < ApplicationRecord
  has_and_belongs_to_many :trainings
  has_and_belongs_to_many :training_sessions
  # belongs_to :training_session
  # enum workout_type: [:power, :plyo, :deload, :hiit]
  has_one_attached :photo
  has_one_attached :video
  has_many :exercises_workouts
  has_many :exercises, through: :exercises_workouts
  accepts_nested_attributes_for :exercises_workouts, allow_destroy: true

  def show_hash
    {
      id: id,
      name:name,
      cn_name: cn_name,
      description: description,
      cn_description: cn_description,
      photo: photo.attached? ? photo.service_url : "",
      video: video.attached? ? video.service_url : "",
      exercises_workouts: exercises_workouts.map do |ew|
        {
          name: ew.exercise.name,
          cn_name: ew.exercise.cn_name,
          description: ew.exercise.description,
          cn_description: ew.exercise.cn_description,
          photo: ew.exercise.photo.attached? ? ew.exercise.photo.service_url : "",
          video: ew.exercise.video.attached? ? ew.exercise.video.service_url : "",
          reps: ew.reps,
          sets: ew.sets,
          weight: ew.weight,
          time: ew.time_limit
        }
      end
    }
  end
end


def full_name
  "#{name} - #{workout_type}"
end
