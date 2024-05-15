class AddOptionsToTrainingSession < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :can_use_dropin, :boolean, default: true
    add_column :training_sessions, :can_use_credits, :boolean, default: true
    add_column :training_sessions, :can_use_packs, :boolean, default: true
    add_column :training_sessions, :can_use_unlimited, :boolean, default: true
    add_column :training_sessions, :can_use_voucher, :boolean, default: true
    add_column :trainings, :can_use_dropin, :boolean, default: true
    add_column :trainings, :can_use_credits, :boolean, default: true
    add_column :trainings, :can_use_packs, :boolean, default: true
    add_column :trainings, :can_use_unlimited, :boolean, default: true
    add_column :trainings, :can_use_voucher, :boolean, default: true
    add_column :memberships, :is_voucher, :boolean, default: false
    add_column :membership_types, :is_voucher, :boolean, default: false
  end
end
