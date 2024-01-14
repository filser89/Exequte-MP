class TrainingSessionRanking < ApplicationRecord
  belongs_to :training_session
  belongs_to :user
  validates :ranking, presence: true


  def show_hash
    h = {
      ranking: ranking,
      calories: calories
    }
    h[:user] = user.ranking_hash
    h
  end
end