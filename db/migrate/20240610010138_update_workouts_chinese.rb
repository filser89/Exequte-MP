class UpdateWorkoutsChinese < ActiveRecord::Migration[6.0]
  def change
    add_column :workouts, :cn_blocks_duration_text, :string
    add_column :workouts, :cn_block_a_format, :string
    add_column :workouts, :cn_block_b_format, :string
    add_column :workouts, :cn_block_c_format, :string
    add_column :workouts, :cn_block_a_title, :string
    add_column :workouts, :cn_block_b_title, :string
    add_column :workouts, :cn_block_c_title, :string
    add_column :workouts, :cn_block_a_duration_format, :string
    add_column :workouts, :cn_block_b_duration_format, :string
    add_column :workouts, :cn_block_c_duration_format, :string
    add_column :workouts, :cn_block_a_reps_text, :string
    add_column :workouts, :cn_block_b_reps_text, :string
    add_column :workouts, :cn_block_c_reps_text, :string
    add_column :workouts, :cn_warmup_duration_format, :string
    add_column :workouts, :cn_finisher_title, :string
    add_column :workouts, :cn_finisher_format, :string
    add_column :workouts, :cn_finisher_duration_format, :string
    add_column :workouts, :cn_finisher_reps_text, :string
  end
end
