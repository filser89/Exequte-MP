class TrainingSessionsController < ApplicationController

  def new
    @training_session = TrainingSession.new
  end

  def custom
    @training_session = TrainingSession.new
  end

  def create
    puts "Params: #{params.inspect}"
    if permitted_params[:times].present?
      puts 'params times present'
      create_multiple_sessions(permitted_params[:times], permitted_params[:credits_list])
    else
      puts 'no params times present'
      @training_session = TrainingSession.new(permitted_params)
      if permitted_params[:training_id] == ""
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
        @training_session.is_fitness_test = @training.is_fitness_test
        @training_session.can_use_dropin = @training.can_use_dropin
        @training_session.can_use_credits = @training.can_use_credits
        @training_session.can_use_packs = @training.can_use_packs
        @training_session.can_use_unlimited = @training.can_use_unlimited
        @training_session.can_use_voucher = @training.can_use_voucher

        if permitted_params[:price_1_cents] == ""
          set_default_prices
        else
          @training_session.price_1 = permitted_params[:price_1_cents]
          @training_session.price_2 = permitted_params[:price_1_cents]
          @training_session.price_3 = permitted_params[:price_1_cents]
          @training_session.price_4 = permitted_params[:price_1_cents]
          @training_session.price_5 = permitted_params[:price_1_cents]
          @training_session.price_6 = permitted_params[:price_1_cents]
          @training_session.price_7 = permitted_params[:price_1_cents]
        end

        if permitted_params[:workout_ids].present?
          puts "found a workout id: #{permitted_params[:workout_ids]}"
          puts "workout_ids content: #{permitted_params[:workout_ids].first}"
          puts "workout_ids length: #{permitted_params[:workout_ids].first.length}"
          puts "workout_ids characters: #{permitted_params[:workout_ids].first.chars}"
          @training_session.workouts = Workout.find(permitted_params[:workout_ids].reject(&:empty?).map(&:to_i))
        else
          puts "workout_ids is blank or nil. Setting it to default value."
          @training_session.workouts = @training.workouts
        end

        @training_session.class_kind = @training.class_type.kind
        @training_session.enforce_cancellation_policy = true
        @training_session.late_booking_minutes = @training.late_booking_minutes
        @training_session.is_limited = @training.is_limited
        if permitted_params[:cancel_before].present? && !permitted_params[:cancel_before].empty?
          @training_session.cancel_before = permitted_params[:cancel_before]
          puts "cancel_before=#{permitted_params[:cancel_before]}"
        else
          @training_session.cancel_before = @training.class_type.cancel_before
        end
        if permitted_params[:credits].present? && !permitted_params[:credits].empty?
          puts "credits=#{permitted_params[:credits]}"
          @training_session.credits = permitted_params[:credits]
        else
          @training_session.credits = @training.credits
        end
        if  permitted_params[:location].present? && !permitted_params[:location].empty?
          puts "location=#{permitted_params[:location]}"
          @training_session.location = permitted_params[:location]
        else
          @training_session.location = @training.location
        end

        # Handle the poster_photo attachment
        begin
          if @training.poster_photo.attached?
            @training_session.poster_photo.attach(@training.poster_photo.blob)
          end
        rescue => e
          puts e
        end

        if @training_session.save
          create_for_weeks(params[:weeks], @training_session)
          redirect_to @training_session
        else
          render :new
        end
      end
    end
  end

  def set_default_prices
    @training_session.price_1 = @training.class_type.price_1
    @training_session.price_2 = @training.class_type.price_2
    @training_session.price_3 = @training.class_type.price_3
    @training_session.price_4 = @training.class_type.price_4
    @training_session.price_5 = @training.class_type.price_5
    @training_session.price_6 = @training.class_type.price_6
    @training_session.price_7 = @training.class_type.price_7
  end
  def create_multiple_sessions(times, credits)
    puts 'inside create_multiple_sessions'
    puts "Times: #{times.inspect}"
    puts "Credits: #{credits.inspect}"
    begin
      times.each_with_index do |time, index|
        # Create a new TrainingSession for each time in the array
        puts "Creating session for time: #{time} with credits: #{credits[index]}"
        @training_session = TrainingSession.new(permitted_params.except(:times, :credits_list).merge(begins_at: time, credits: credits[index]))
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
        @training_session.is_fitness_test = @training.is_fitness_test
        @training_session.can_use_dropin = @training.can_use_dropin
        @training_session.can_use_credits = @training.can_use_credits
        @training_session.can_use_packs = @training.can_use_packs
        @training_session.can_use_unlimited = @training.can_use_unlimited
        @training_session.can_use_voucher = @training.can_use_voucher
        price_per_credit = {
          12 => 130,
          15 => 150,
          17 => 180,
          20 => 239,
          25 => 288,
          30 => 349,
          50 => 700,
          70 => 1000
        }
        credit = credits[index].to_i

        if credit.present? && credit < 100
          begin
            puts "Calculating price from credits"
            price = price_per_credit[credit]
            if price.nil?
              puts "No match found, using default multiplier"
              multiplier = 10 # using highest price
              price = credit * multiplier
            else
              puts "Price for #{credit} credits: #{price}元"
            end
            @training_session.price_1 = price
            @training_session.price_2 = price
            @training_session.price_3 = price
            @training_session.price_4 = price
            @training_session.price_5 = price
            @training_session.price_6 = price
            @training_session.price_7 = price
          rescue StandardError => e
            puts e.message
            puts "Error calculating price from credits, defaulting to training credits"
            set_default_prices
          end
        else
          set_default_prices
        end
        if permitted_params[:workout_ids].present?
          puts "found a workout id: #{permitted_params[:workout_ids]}"
          puts "workout_ids content: #{permitted_params[:workout_ids].first}"
          puts "workout_ids length: #{permitted_params[:workout_ids].first.length}"
          puts "workout_ids characters: #{permitted_params[:workout_ids].first.chars}"
          @training_session.workouts = Workout.find(permitted_params[:workout_ids].reject(&:empty?).map(&:to_i))
        else
          puts "workout_ids is blank or nil. Setting it to default value."
          @training_session.workouts = @training.workouts
        end

        @training_session.class_kind = @training.class_type.kind
        @training_session.enforce_cancellation_policy = true
        @training_session.late_booking_minutes = @training.late_booking_minutes
        @training_session.is_limited = @training.is_limited
        if permitted_params[:cancel_before].present? && !permitted_params[:cancel_before].empty?
          @training_session.cancel_before = permitted_params[:cancel_before]
          puts "cancel_before=#{permitted_params[:cancel_before]}"
        else
          @training_session.cancel_before = @training.class_type.cancel_before
        end
        if permitted_params[:location].present? && !permitted_params[:location].empty?
          puts "location=#{permitted_params[:location]}"
          @training_session.location = permitted_params[:location]
        else
          @training_session.location = @training.location
        end

        # Handle the poster_photo attachment
        begin
          if @training.poster_photo.attached?
            @training_session.poster_photo.attach(@training.poster_photo.blob)
          end
        rescue => e
          puts e
        end
        if @training_session.save
          puts "training session saved correctly"
        else
          puts "error saving training session"
        end
        # unless @training_session.save
        #   puts "Error saving session"
        #   @training_session.errors.each do |attribute, message|
        #     puts "#{attribute}: #{message}"
        #   end
        #   # Handle the case where a session couldn't be saved
        #   # For example, log errors or provide feedback to the user
        # end
      end
    rescue => e
      puts "Error: #{e.message}"
      puts "Backtrace: #{e.backtrace.join("\n")}"
    end
    redirect_to @training_session
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
        workouts: training_session.workouts,
        name: training_session.name,
        cn_name: training_session.cn_name,
        subtitle: training_session.subtitle,
        cn_subtitle: training_session.cn_subtitle,
        description: training_session.description,
        cn_description: training_session.cn_description,
        duration: training_session.duration,
        capacity: training_session.capacity,
        calories: training_session.calories,
        is_fitness_test: training_session.is_fitness_test,
        can_use_dropin: training_session.can_use_dropin,
        can_use_credits: training_session.can_use_credits,
        can_use_packs: training_session.can_use_packs,
        can_use_unlimited: training_session.can_use_unlimited,
        can_use_voucher: training_session.can_use_voucher,
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
        is_limited: training_session.is_limited,
        poster_photo: training_session.poster_photo.attached? ? training_session.poster_photo.blob : nil,
        location: training_session.location,
        credits: training_session.credits
      )
    end
  end

  def permitted_params
    params.require(:training_session).permit(
      :training_id,
      :begins_at,
      :user_id,
      :price_1_cents,
      :cancel_before,
      :credits,
      :location,
      workout_ids: [],
      times: [],
      credits_list: []
    ).transform_values(&:presence)
  end
end
