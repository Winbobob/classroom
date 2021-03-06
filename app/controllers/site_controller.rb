# frozen_string_literal: true

class SiteController < ApplicationController
  layout :none

  before_action :authorize_access

  def boom_town
    raise "BOOM"
  end

  private

  def authorize_access
    not_found unless current_user.try(:staff?)
  end
end
