# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'UserLogin', type: :feature do
  let(:user) { create(:user, password: 'password') }
end
