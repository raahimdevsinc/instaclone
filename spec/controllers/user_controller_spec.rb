# frozen_string_literal: true

# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { User.create(username: 'example_user', email: 'example@example.com', password: 'password') }

  before do
    sign_in user
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'renders the show template' do
      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested user to @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end
end
