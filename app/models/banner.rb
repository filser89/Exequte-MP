class Banner < ApplicationRecord
  has_one_attached :photo
  default_scope -> { where(destroyed_at: nil) }
  after_save :remove_current_from_others
  after_create :notify_users_on_create
  after_update :notify_users_on_update

  def standard_hash
    h = {
      id: id,
    }
    h[:url] =  photo.service_url if photo.attached?
    h
  end

  def remove_current_from_others
    Banner.where(current: true).where("id != ?", id).update_all(current: false) if self.current == true
  end

  def notify_users_on_create
    puts "INSIDE AFTER CREATE"
    User.notify_all!(self) if self.current == true
  end

  def notify_users_on_update
    puts "INSIDE AFTER UPDATE"
    condition = self.saved_change_to_current && self.current == true
    p condition
    User.notify_all!(self) if condition
  end
end
