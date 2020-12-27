class TrainingSessionsController < ApplicationController

  def new
    @training_session = TrainingSession.new
  end

  def create
    @training_session = TrainingSession.new(permited_params)
    @training = @training_session.training
    @training_session.name = @training.name
    @training_session.cn_name = @training.cn_name
    @training_session.description = @training.description
    @training_session.cn_description = @training.cn_description
    @training_session.duration = @training.duration
    @training_session.capacity = @training.capacity
    @training_session.calories = @training.calories
    @training_session.price_1 = @training.class_type.price_1
    @training_session.price_2 = @training.class_type.price_2
    @training_session.price_3 = @training.class_type.price_3
    @training_session.price_4 = @training.class_type.price_4
    @training_session.price_5 = @training.class_type.price_5
    @training_session.price_6 = @training.class_type.price_6
    @training_session.price_7 = @training.class_type.price_7
    @training_session.cancel_before = @training.class_type.cancel_before
    @training_session.class_kind = @training.class_type.kind
    if @training_session.save!
      redirect_to @training_session
    else
      render :new
    end
  end

  def show
    @training_session = TrainingSession.find(params[:id])
  end


  def permited_params
    params.require(:training_session).permit(:training_id, :begins_at, :user_id)
  end
end
