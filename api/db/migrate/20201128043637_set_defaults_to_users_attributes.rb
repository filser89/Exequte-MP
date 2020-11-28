class SetDefaultsToUsersAttributes < ActiveRecord::Migration[6.0]
  def change
change_column_default :users, :city, nil
change_column_default :users, :wechat, nil
change_column_default :users, :phone, nil
change_column_default :users, :email, nil
change_column_default :users, :gender, nil
change_column_default :users, :admin, false
change_column_default :users, :wx_open_id, nil
change_column_default :users, :wx_session_key, nil
  end
end
