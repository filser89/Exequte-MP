# app/models/logged_workout.rb
class LoggedWorkout < ApplicationRecord
  belongs_to :user
  belongs_to :workout
  belongs_to :booking  # Add this line to establish the relationship
  has_many :logged_exercises
  has_many :exercises, through: :logged_exercises
  VALIDATION_OPTIONS = [nil, 'none', 'approved', 'pending', 'denied']
  validates :validation_status, inclusion: VALIDATION_OPTIONS
  accepts_nested_attributes_for :logged_exercises, allow_destroy: true
  #has_many :logged_exercises, dependent: :destroy

  def show_hash_blocks
    blocks = logged_exercises.group_by(&:block).transform_values do |exercises|
      exercises.sort_by { |ew| ew.order ? ew.order : ew.id }.map do |ew|
        exercise = ew.exercise

        {
          id: ew&.id,
          name: exercise&.name.presence || "",
          cn_name: exercise&.cn_name.presence || "",
          description: exercise&.description.presence || "",
          cn_description: exercise&.cn_description.presence || "",
          photo: exercise&.photo&.attached? ? exercise.photo.service_url : "",
          video: exercise&.video&.attached? ? exercise.video.service_url : "",
          reps: ew.reps.presence || "",
          reps_gold: ew.reps_gold.presence || "",
          reps_silver: ew.reps_silver.presence || "",
          reps_bronze: ew.reps_bronze.presence || "",
          format: ew.format.presence || "",
          sets: ew.sets.presence || "",
          time_limit: ew.time_limit.presence || "",
          order: ew.order.presence || "",
          comments: ew.comments.presence || "",
          weight: ew.weight.presence || ""
        }
      end
    end

    if workout.present?
      {
        id: id,
        workout_id: workout.id,
        name: workout.name.presence || "",
        workout_type: workout.workout_type.presence || "",
        cn_name: workout.cn_name.presence || "",
        description: workout.description.presence || "",
        cn_description: workout.cn_description.presence || "",
        destroyed_at: workout.destroyed_at.presence || "",
        created_at: workout.created_at.presence || "",
        updated_at: workout.updated_at.presence || "",
        quote: workout.quote.presence || "",
        cn_quote: workout.cn_quote.presence || "",
        title: workout.title.presence || "",
        cn_title: workout.cn_title.presence || "",
        title_footer: workout.title_footer.presence || "",
        cn_title_footer: workout.cn_title_footer.presence || "",
        level: workout.level.presence || "",
        total_duration: workout.total_duration.presence || "",
        warmup_duration: workout.warmup_duration.presence || "",
        warmup_exercise_duration: workout.warmup_exercise_duration.presence || "",
        blocks_duration: workout.blocks_duration.presence || "",
        blocks_rounds: workout.blocks_rounds.presence || "",
        blocks_duration_text: workout.blocks_duration_text.presence || "",
        blocks_exercise_duration: workout.blocks_exercise_duration.presence || "",
        cooldown_duration: workout.cooldown_duration.presence || "",
        breathing_duration: workout.breathing_duration.presence || "",
        block_a_format: workout.block_a_format.presence || "",
        block_b_format: workout.block_b_format.presence || "",
        block_c_format: workout.block_c_format.presence || "",
        block_a_title: workout.block_a_title.presence || "",
        block_b_title: workout.block_b_title.presence || "",
        block_c_title: workout.block_c_title.presence || "",
        block_a_duration_format: workout.block_a_duration_format.presence || "",
        block_b_duration_format: workout.block_b_duration_format.presence || "",
        block_c_duration_format: workout.block_c_duration_format.presence || "",
        block_a_reps_text: workout.block_a_reps_text.presence || "",
        block_b_reps_text: workout.block_b_reps_text.presence || "",
        block_c_reps_text: workout.block_c_reps_text.presence || "",
        warmup_duration_format: workout.warmup_duration_format.presence || "",
        finisher_title: workout.finisher_title.presence || "",
        finisher_format: workout.finisher_format.presence || "",
        finisher_duration_format: workout.finisher_duration_format.presence || "",
        finisher_reps_text: workout.finisher_reps_text.presence || "",
        training_id: workout.training_id.presence || "",
        training_session_id: workout.training_session_id.presence || "",
        photo: workout.photo.attached? ? workout.photo.service_url : "",
        video: workout.video.attached? ? workout.video.service_url : "",
        exercises_workouts: blocks,
        validated: validated,
        validated_at: validated_at,
        validated_by: validated_by,
        validation_status: validation_status,
        validation_request_at: validation_request_at
      }
    end
  end
end
