# frozen_string_literal: true
module Stafftools
  class GroupingsController < StafftoolsController
    before_action :set_grouping

    def show; end

    def destroy
      org = @grouping.organization

      GroupAssignment.where(grouping: @grouping).each(&:destroy)
      @grouping.destroy

      flash[:success] = 'Grouping was destroyed'
      redirect_to stafftools_organization_path(org.id)
    end

    private

    def set_grouping
      @grouping = Grouping.find_by!(id: params[:id])
    end
  end
end
