require 'spec_helper'

shared_examples 'a protected route' do
  let(:options) { {} }

  context 'as a user with access' do
    before { login_as(authorized_user) }

    it 'grants access' do
      get route, options
      if response.status == 302
        expect(response).to redirect_to(root_path)
      else
        expect(response.status).to eq(200)
      end
    end
  end

  context 'as a user without access' do
    before { login_as(create(:user)) }

    it 'denies access' do
      get route, options
      expect(response).to redirect_to(oauth_signin_path)
      expect(response.status).to eq(302)
    end
  end
end

shared_examples 'an unprotected route' do
  let(:options) { {} }

  context 'as an unauthenticated user' do
    it 'grants access' do
      get route, options
      expect(response.status).to eq(200)
    end
  end
end

