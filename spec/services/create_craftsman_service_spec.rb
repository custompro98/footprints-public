require 'spec_helper'

describe CreateCraftsmanService do
  describe '#create' do
    let(:attrs) {
      {
        :name => "test craftsman",
        :employment_id => "123",
        :status => "test status"
      }
    }

    let!(:user_role) { create(:user_role) }

    it 'creates an old craftsman model and a new user model' do
      described_class.create(attrs)

      expect(Craftsman.all.first.name).to eq('test craftsman')
      expect(NewUser.all.first.name).to eq('test craftsman')
    end

    it 'links the old craftsman model to the new user model' do
      described_class.create(attrs)

      expect(NewUser.all.first.original_user).to eq(Craftsman.all.first)

    end

  end
end
