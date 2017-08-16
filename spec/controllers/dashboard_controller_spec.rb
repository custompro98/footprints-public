require 'spec_helper'
require 'controllers/shared_examples/route'

describe DashboardController do
  let(:authorized_user) { create(:user, employee: true) }

  before do
    allow(DashboardInteractor).to receive(:new).and_return(dashboard_interactor)
  end

  describe '#index' do
    let(:route) { :index }

    let(:authorized_user_with_craftsman) { create(:user, employee: true, create_craftsman: true) }
    let(:confirmed_applicant) { build(:applicant) }
    let(:unconfirmed_applicant) {build(:applicant) }

    let(:dashboard_interactor) { double('DashboardInteractor', confirmed_applicants: [confirmed_applicant],
                                                             not_yet_responded_applicants: [unconfirmed_applicant]) }
    let(:applicant_index_presenter) { double('ApplicantIndexPresenter') }

    before do
      login_as(authorized_user_with_craftsman)
      allow(ApplicantIndexPresenter).to receive(:new).and_return(applicant_index_presenter)
    end

    it_behaves_like 'a protected route'

    it 'finds correct craftsman and applicants for index' do
      get route

      expect(assigns(:craftsman)).to eq(authorized_user_with_craftsman.craftsman)
      expect(assigns(:confirmed_applicants)).to eq([confirmed_applicant])
      expect(assigns[:not_yet_responded_applicants]).to eq([unconfirmed_applicant])
    end
  end

  describe '#confirm_applicant_assignment' do
    let(:route) { :confirm_applicant_assignment }

    let(:unconfirmed_applicant) { build(:applicant) }

    let(:applicant_repository) { double('ApplicantRepository', find_by_id: unconfirmed_applicant) }
    let(:dashboard_interactor) { double('DashboardInteractor', assign_steward_for_applicant: nil) }

    before do
      login_as(authorized_user)
      allow(Footprints::Repository).to receive(:applicant).and_return(applicant_repository)
    end

    it_behaves_like 'a protected route'

    it 'confirms an assignment and redirects to the root path' do
      get route, { id: unconfirmed_applicant.id }

      expect(assigns(:applicant)).to eq(unconfirmed_applicant)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Confirmed')
    end
  end

  describe '#decline_applicant_assignment' do
    let(:route) { :decline_applicant_assignment }

    let(:unconfirmed_applicant) { build(:applicant) }

    let(:applicant_repository) { double('ApplicantRepository', find_by_id: unconfirmed_applicant) }
    let(:dashboard_interactor) { double('DashboardInteractor', decline_applicant: nil,
                                                               assign_new_craftsman: nil) }

    before do
      login_as(authorized_user)
      allow(Footprints::Repository).to receive(:applicant).and_return(applicant_repository)
    end

    it_behaves_like 'a protected route'

    it 'declines an assignment and redirects to the root path' do
      get route, { id: unconfirmed_applicant.id }

      expect(assigns(:applicant)).to eq(unconfirmed_applicant)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Declined')
    end
  end

  describe '#decline_all_applicants' do
    let(:route) { :decline_all_applicants }

    let(:dashboard_interactor) { double('DashboardInteractor', decline_all_applicants_and_set_availability_date: nil) }

    before do
      login_as(authorized_user)
    end

    it_behaves_like 'a protected route'

    context 'is successful' do
      it 'declines all applicants and redirects to the root path' do
        post route

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Declined All Applicants')
      end
    end

    context 'is unsuccessful' do
      before do
        allow(dashboard_interactor).to receive(:decline_all_applicants_and_set_availability_date).and_raise(DashboardInteractor::InvalidAvailabilityDate)
      end

      it 'redirects to the root path' do
        post route

        expect(flash[:error]).to be_present
      end
    end
  end
end
