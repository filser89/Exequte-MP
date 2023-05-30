
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
  scope :order_by_name, -> { order('name ASC')}
  scope :order_by_title, -> { order('title ASC')}

  def show_hash
    {
      id: id,
      name:name,
      cn_name: cn_name,
      description: description,
      cn_description: cn_description,
      quote: quote,
      cn_quote: cn_quote,
      title: title,
      cn_title: cn_title,
      title_footer: title_footer,
      cn_title_footer: cn_title_footer,
      level: level,
      total_duration: total_duration,
      warmup_duration: warmup_duration,
      warmup_exercise_duration: warmup_exercise_duration,
      cooldown_duration: cooldown_duration,
      breathing_duration: breathing_duration,
      blocks_rounds: blocks_rounds,
      blocks_duration: blocks_duration,
      blocks_duration_text: blocks_duration_text,
      blocks_exercise_duration: blocks_exercise_duration,
      block_a_format: block_a_format,
      block_b_format: block_b_format,
      block_c_format: block_c_format,
      block_a_title: block_a_title,
      block_b_title: block_a_title,
      block_c_title: block_c_title,
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
          reps_gold: ew.reps_gold,
          reps_silver: ew.reps_silver,
          reps_bronze: ew.reps_bronze,
          block: ew.block,
          format: ew.format,
          sets: ew.sets,
          time: ew.time_limit
        }
      end
    }
  end
end


def full_name
  "#{name} - #{workout_type}"
end
