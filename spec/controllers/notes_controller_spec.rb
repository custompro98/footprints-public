require 'spec_helper'

describe NotesController do
  let(:repo)      { Footprints::Repository }
  let(:applicant) { repo.applicant.create(:name => "First", :applied_on => Date.current,
                                          :discipline => "developer", :skill => "resident", :location => "Chicago") }
  let(:craftsman_id) { 1 }
  let(:craftsman) { double(:craftsman, :id => craftsman_id) }
  let(:mock_user) { double(::User, craftsman_id: craftsman_id, uid: 1, craftsman: craftsman)}

  before :each do
    repo.notes.destroy_all
    allow(repo).to receive(:user).and_return(double(::ArRepository::UserRepository, find_by_id: mock_user))
  end

  context 'before_filters' do
    let(:craftsman_id) { nil }

    it "redirects to home page when not a craftsman" do
      post :create, {"note" => {"body" => "Test Note", "applicant_id" => applicant.id}}, {:user_id => 1}
      expect(response).to redirect_to(root_url)
    end
  end

  context ":create" do
    it "creates note if user has craftsman" do
      post :create, {"note" => {"body" => "Test Note", "applicant_id" => applicant.id}}, {:user_id => 1}
      expect(applicant.notes.last.body).to eq "Test Note"
    end

    context 'with no craftsman' do
      let(:craftsman) { nil }

      it "redirects back to applicant if note cannot be created" do
        post :create, {"note" => {"body" => "Test Note", "applicant_id" => applicant.id}}, {:user_id => 1}
        expect(flash[:notice]).to eq("Only craftsmen can leave notes.")
        expect(response).to redirect_to(applicant_path(applicant))
      end
    end
  end

  context ":edit" do
    it "gets the correct note" do
      note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id, :craftsman_id => craftsman.id)
      get :edit, {:id => note.id}, {:user_id => 1}
      expect(assigns[:note]).to eq(note)
    end
  end

  context ":update" do
    it "updates a note" do
      note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id, :craftsman_id => craftsman.id)
      patch :update, {"id" => note.id, "note" => {"id" => note.id, "body" => "Test Note Edit"}}, {:user_id => 1}
      expect(note.reload.body).to eq("Test Note Edit")
      expect(response).to redirect_to(applicant_path(applicant))
    end

    context 'without a craftsman' do
      let(:craftsman) { nil }

      it "redirects back to applicant if note cannot be updated" do
        note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id)
        patch :update, {"id" => note.id, "note" => {"id" => note.id, "body" => "Test Note Edit"}}, {:user_id => 1}
        expect(note.reload.body).to eq("Test Note")
        expect(flash.notice).to eq("Only craftsmen can edit notes.")
        expect(response).to redirect_to(applicant_path(applicant))
      end
    end
  end
end
