# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :redirect_to_login_unless_logged_in, only: %i[create destroy]

  def create
  end

  def destroy
  end
end
