# frozen_string_literal: true

class LoggedWorkoutsController < ApplicationController

  def new
    @logged_workout = LoggedWorkout.new
  end

end

