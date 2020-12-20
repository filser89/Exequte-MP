class RenameColumnInClassTypes < ActiveRecord::Migration[6.0]
  change_table :class_types do |t|
    t.rename :type, :kind
  end
end
