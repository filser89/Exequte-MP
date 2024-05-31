class AddSettingsToBanners < ActiveRecord::Migration[6.0]
  def change
    add_column :banners, :settings, :jsonb
  end
end
