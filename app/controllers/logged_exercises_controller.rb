# frozen_string_literal: true

class LoggedExercisesController < ApplicationController

  def new
    @logged_exercise = LoggedExercise.new
  end

end

