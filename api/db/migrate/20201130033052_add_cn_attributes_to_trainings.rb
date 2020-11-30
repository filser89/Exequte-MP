class AddCnAttributesToTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :cn_name, :string
    add_column :trainings, :cn_description, :text
  end
end
