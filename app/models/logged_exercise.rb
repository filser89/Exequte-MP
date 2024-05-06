# app/models/logged_exercise.rb
class LoggedExercise < ApplicationRecord
  belongs_to :logged_workout
  belongs_to :exercise
  attribute :batch_index, :integer

  def standard_hash
    h = {
      id: id,
      name: exercise&.name,
      batch_index: batch_index,
      block: block,
      comments: comments,
      created_at: created_at,
      logged_workout_date: logged_workout&.booking&.training_session&.begins_at,
      logged_workout_id: logged_workout&.id,
      logged_workout_validation_status: logged_workout&.validation_status,
      exercise_id: exercise&.id,
      format: format,
      order: order,
      reps: reps,
      reps_bronze: reps_bronze,
      reps_gold: reps_gold,
      reps_silver: reps_silver,
      sets: sets,
      time_limit: time_limit,
      updated_at: updated_at,
      weight: weight
    }
    h
  end

end
