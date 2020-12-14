class AddInstructorBioToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :instructor_bio, :string
    add_column :users, :cn_instructor_bio, :string
  end
end
