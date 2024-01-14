ActiveAdmin.register TrainingSessionRanking do
  permit_params :ranking, :calories, :training_session_id, :user_id

  index do
    selectable_column
    id_column
    column :ranking
    column :calories
    column :training_session
    column :user
    actions
  end

  form do |f|
    f.inputs 'Training Session Ranking Details' do
      f.input :ranking
      f.input :calories
      f.input :training_session, as: :select, collection: TrainingSession.all.map { |ts| [ts.id, ts.id] }
      f.input :user, as: :select, collection: User.all.map { |user| [user.full_name, user.id] }
    end
    f.actions
  end
end
