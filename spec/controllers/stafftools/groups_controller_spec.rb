# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Stafftools::GroupsController, type: :controller do
  let(:organization) { classroom_org }
  let(:user)         { organization.users.first }

  let(:grouping) { create(:grouping, organization: organization)         }
  let(:group)    { Group.create(grouping: grouping, title: 'The B Team') }

  before(:each) do
    sign_in_as(user)
  end

  after(:each) do
    Group.destroy_all
  end

  describe 'GET #show', :vcr do
    context 'as an unauthorized user' do
      it 'returns a 404' do
        expect { get :show, params: { id: group.id } }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'as an authorized user' do
      before do
        user.update_attributes(site_admin: true)
        get :show, params: { id: group.id }
      end

      it 'succeeds' do
        expect(response).to have_http_status(:success)
      end

      it 'sets the GroupAssignment' do
        expect(assigns(:group).id).to eq(group.id)
      end
    end
  end

  describe 'DELETE #destroy', :vcr do
    context 'as an unauthorized user' do
      it' returns a 404' do
        expect { delete :destroy, params: { id: group.id } }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'as an authorized user' do
      before do
        user.update_attributes(site_admin: true)
        delete :destroy, params: { id: group.id }
      end

      it 'deletes the group' do
        expect(Group.find_by(id: group.id)).to be_nil
      end

      it 'shows an informative message' do
        expect(flash[:success]).to eq('Group was destroyed')
      end

      it 'redirects to grouping page' do
        expect(response).to redirect_to(stafftools_grouping_path(group.grouping.id))
      end
    end
  end
end
