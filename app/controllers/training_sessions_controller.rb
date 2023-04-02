class TrainingSessionsController < ApplicationController

  def new
    @training_session = TrainingSession.new
  end

  def create
    @training_session = TrainingSession.new(permited_params)
    if permited_params[:training_id] == ""
      render :new
    else
      @training = @training_session.training
      @training_session.name = @training.name
      @training_session.cn_name = @training.cn_name
      @training_session.description = @training.description
      @training_session.subtitle = @training.subtitle
      @training_session.cn_subtitle = @training.cn_subtitle
      @training_session.cn_description = @training.cn_description
      @training_session.duration = @training.duration
      @training_session.capacity = @training.capacity
      @training_session.calories = @training.calories
      if permited_params[:price_1_cents] == ""
        @training_session.price_1 = @training.class_type.price_1
        @training_session.price_2 = @training.class_type.price_2
        @training_session.price_3 = @training.class_type.price_3
        @training_session.price_4 = @training.class_type.price_4
        @training_session.price_5 = @training.class_type.price_5
        @training_session.price_6 = @training.class_type.price_6
        @training_session.price_7 = @training.class_type.price_7
      else
        @training_session.price_1 = permited_params[:price_1_cents]
        @training_session.price_2 = permited_params[:price_1_cents]
        @training_session.price_3 = permited_params[:price_1_cents]
        @training_session.price_4 = permited_params[:price_1_cents]
        @training_session.price_5 = permited_params[:price_1_cents]
        @training_session.price_6 = permited_params[:price_1_cents]
        @training_session.price_7 = permited_params[:price_1_cents]
      end
      @training_session.class_kind = @training.class_type.kind
      @training_session.enforce_cancellation_policy = true
      @training_session.late_booking_minutes = @training.late_booking_minutes
      @training_session.is_limited = @training.is_limited
      if permited_params[:cancel_before] == ""
        @training_session.cancel_before = @training.class_type.cancel_before
      else
        @training_session.cancel_before = permited_params[:cancel_before]
      end
      if @training_session.save
        create_for_weeks(params[:weeks], @training_session)
        redirect_to @training_session
      else
        render :new
      end
    end
  end

  def show
    @training_session = TrainingSession.find(params[:id])
    @weeks_ts = TrainingSession.where("id > ?", @training_session.id)
  end

  def create_for_weeks(weeks, training_session)
    weeks.to_i.times do |n|
      i = n + 1
      ts = TrainingSession.create(
        training: training_session.training,
        instructor: training_session.instructor,
        name: training_session.name,
        cn_name: training_session.cn_name,
        subtitle: training_session.subtitle,
        cn_subtitle: training_session.cn_subtitle,
        description: training_session.description,
        cn_description: training_session.cn_description,
        duration: training_session.duration,
        capacity: training_session.capacity,
        calories: training_session.calories,
        price_1: training_session.price_1,
        price_2: training_session.price_2,
        price_3: training_session.price_3,
        price_4: training_session.price_4,
        price_5: training_session.price_5,
        price_6: training_session.price_6,
        price_7: training_session.price_7,
        cancel_before: training_session.cancel_before,
        class_kind: training_session.class_kind,
        begins_at: training_session.begins_at + i.weeks,
        enforce_cancellation_policy: training_session.enforce_cancellation_policy,
        note: training_session.note,
        late_booking_minutes: training_session.late_booking_minutes,
        is_limited: training_session.is_limited
      )
    end
  end

  def permited_params
    params.require(:training_session).permit(:training_id, :begins_at, :user_id, :price_1_cents, :cancel_before)
  end
end
