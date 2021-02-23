require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'validations' do
        it { should validate_presence_of :name }
    end

    describe 'relationships' do
        it { should have_many :user_conversations }
        it { should have_many(:conversations).through(:user_conversations) }
        it { should have_many :messages }
    end
end