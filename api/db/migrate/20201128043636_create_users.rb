class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :city
      t.string :wechat
      t.string :phone
      t.string :email
      t.string :gender
      t.boolean :admin
      t.string :wx_open_id
      t.string :wx_session_key

      t.timestamps
    end
  end
end
