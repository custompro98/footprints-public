require 'spec_helper'
require "./lib/applicants/applicant_profile_presenter"

describe ApplicantProfilePresenter do
  # for #has_background?
  let(:codeschool) { nil }
  let(:college_degree) { nil }
  let(:cs_degree) { nil }
  let(:worked_as_dev) { nil }

  # for #has_application_questions?
  let(:about) { nil }
  let(:software_interest) { nil }
  let(:reason) { nil }

  # for #current_state
  let(:initial_reply_on) { nil }
  let(:sent_challenge_on) { nil }
  let(:completed_challenge_on) { nil }
  let(:reviewed_on) { nil }
  let(:offered_on) { nil }
  let(:completed_challenge_on) { nil }
  let(:decision_made_on) { nil }

  # for #url
  let(:url) { nil }

  # for #hire_action
  let(:hired) { 'no decision' }
  let(:start_date) { nil }
  let(:end_date) { nil }

  # for #can_be_unarchived?
  let(:archived) { true }

  let(:applicant) do
    OpenStruct.new(
      name: 'Meagan',
      applied_on: Date.parse('20140101'),
      initial_reply_on: initial_reply_on,
      sent_challenge_on: sent_challenge_on,
      completed_challenge_on: completed_challenge_on,
      reviewed_on: reviewed_on,
      offered_on: offered_on,
      decision_made_on: decision_made_on,
      discipline: 'developer',
      skill: 'resident',
      location: 'Chicago',
      codeschool: codeschool,
      college_degree: college_degree,
      cs_degree: cs_degree,
      worked_as_dev: worked_as_dev,
      about: about,
      software_interest: software_interest,
      reason: reason,
      url: url,
      hired: hired,
      start_date: start_date,
      end_date: end_date,
      archived: archived
    )
  end

  let(:presenter) { ApplicantProfilePresenter.new(applicant) }

  context '#has_background?' do
    context 'applicant has no background information' do
      shared_examples 'has no background information' do
        it "returns false" do
          presenter.has_background?.should be_false
        end
      end

      context 'applicant has nil codeschool, college_degree, cs_degree and worked_as_dev attributes' do
        it_behaves_like 'has no background information'
      end

      context "applicant has codeschool attribute 'None'" do
        let(:codeschool) { 'None' }

        it_behaves_like 'has no background information'
      end
    end

    context 'applicant has background information' do
      shared_examples 'has background information' do
        it 'returns true' do
          presenter.has_background?.should be_true
        end
      end

      context 'applicant has codeschool attribute' do
        let(:codeschool) { 'Dev Bootcamp' }
        it_behaves_like 'has background information'
      end

      context "applicant has college_degree attribute" do
        let(:college_degree) { 'University of Texas' }
        it_behaves_like 'has background information'
      end

      context "applicant has cs_degree attribute" do
        let(:cs_degree) { 'yes' }
        it_behaves_like 'has background information'
      end

      context "applicant has worked_as_dev attribute" do
        let(:worked_as_dev) { 'yes' }
        it_behaves_like 'has background information'
      end
    end
  end

  context  '#has_application_questions?' do
    context 'applicant has no application questions' do
      it 'returns false' do
        presenter.has_application_questions?.should be_false
      end
    end

    context 'applicant has application questions' do
      shared_examples 'has application questions' do
        it 'returns true' do
          presenter.has_application_questions?.should be_true
        end
      end

      context 'has an about attribute' do
        let(:about) { 'some info' }
        it_behaves_like 'has application questions'
      end

      context 'has a software_interest attribute' do
        let(:software_interest) { 'stuff about software' }
        it_behaves_like 'has application questions'
      end

      context 'has a reason attribute' do
        let(:reason) { 'a real reason' }
        it_behaves_like 'has application questions'
      end
    end
  end

  context '#display_body' do
    it "displays the body of the messages correctly" do
      presenter.display_body("Hello\nIs---This\\Ok").should == "Hello<br/>IsThisOk"
    end
  end

  it "has the most recent interaction" do
    presenter.recent_interaction.should == "Jan 1, 2014"
  end

  it "has the interactions" do
    applicant.initial_reply_on = Date.parse("20140105")
    presenter.interactions.should == {"Initial Reply On"=>"Jan 5, 2014"}
  end

  context '#current_state' do
    context 'applied_on is the only state that is set' do
      it "'returns 'Applied'" do
        presenter.current_state.should == 'Applied'
      end
    end

    context 'initial_reply_on is set' do
      let(:initial_reply_on) { Date.today }

      it "returns 'Contacted'" do
        presenter.current_state.should == 'Contacted'
      end
    end

    context 'sent_challenge_on is set' do
      let(:sent_challenge_on) { Date.today }

      it "returns 'Requested Submission'" do
        presenter.current_state.should == 'Requested Submission'
      end
    end

    context 'completed_challenge_on is set' do
      let(:completed_challenge_on) { Date.today }

      it "returns 'Submitted Code'" do
        presenter.current_state.should == 'Submitted Code'
      end
    end

    context 'reviewed_on is set' do
      let(:reviewed_on) { Date.today }

      it "returns 'Received Feedback'" do
        presenter.current_state.should == 'Received Feedback'
      end
    end

    context 'offered_on is set' do
      let(:offered_on) { Date.today }

      it "returns 'Extended Offer'" do
        presenter.current_state.should == 'Extended Offer'
      end
    end

    context 'decision_made_on is set' do
      let(:decision_made_on) { Date.today }

      it "returns 'Completed Application'" do
        presenter.current_state.should == 'Completed Application'
      end
    end
  end

  context "#url" do
    let(:url) { 'http://www.meaganwaller.com' }

    it "creates valid url syntax" do
      presenter.url.should == Array(url)
    end

    context 'without prefix' do
      let(:url) { 'www.meaganwaller.com' }

      it "add http prefix if otherwise valid url " do
        presenter.url.should == ["http://www.meaganwaller.com"]
      end
    end

    context 'with https prefix' do
      let(:url) { 'https://www.meaganwaller.com' }

      it "doesn't add prefix if url has https prefix" do
        presenter.url.should == ["https://www.meaganwaller.com"]
      end
    end

    context 'invalid url syntax' do
      let(:url) { 'No experience' }

      it "doesn't add http prefix if not otherwise valid" do
        presenter.url.should == []
      end
    end

    context 'multiple urls' do
      let(:url) { 'http://meaganwaller.com http://github.com/meaganewaller' }

      it "handles with multiple urls" do
        presenter.url.should == ["http://meaganwaller.com", "http://github.com/meaganewaller"]
      end

      context 'unneccessary punctation' do
        let(:url) { 'https://meaganwaller.com, http://github.com/meaganewaller;' }

        it "deals with multiple unnecessary punctuation" do
          presenter.url.should == ["https://meaganwaller.com", "http://github.com/meaganewaller"]
        end
      end
    end
  end

  context "#hire_action" do
    context 'applicant is not hired' do
      context 'applicant is ready for hire' do
        let(:start_date) { Date.today }
        let(:end_date) { Date.today + 6.months }

        it "returns a link to the hire action if applicant is ready for hire" do
          expect(presenter.hire_action).to eq("<a href='#' class='decision_made_on button primary'>Hire</a>")
        end
      end

      it "returns nothing if applicant is still going through the application process" do
        expect(presenter.hire_action).to be_nil
      end
    end

    context 'applicant has been hired' do
      let(:hired) { 'yes' }
      it "returns 'Hired'" do
        expect(presenter.hire_action).to eq('Hired')
      end
    end
  end

  context "#applicant_hired?" do
    it "returns false if no hiring decision has been made" do
      expect(presenter.applicant_hired?).to be_false
    end

    context 'applicant was not hired' do
      let(:hired) { 'no' }

      it "returns false if applicant was not hired" do
        expect(presenter.applicant_hired?).to be_false
      end
    end

    context 'applicant was hired' do
      let(:hired) { 'yes' }
      it 'returns true' do
        expect(presenter.applicant_hired?).to be_true
      end
    end
  end

  context "#can_be_unarchived?" do
    context 'applicant is not archived' do
      let(:archived) { false }

      it 'returns false' do
        expect(presenter.can_be_unarchived?).to be_false
      end
    end

    context 'applicant is archived and has not been hired' do
      let(:hired) { 'no' }

      it 'returns true' do
        expect(presenter.can_be_unarchived?).to be_true
      end
    end

    context 'has been archived and hired' do
      let(:hired) { 'yes' }

      it 'returns false' do
        expect(presenter.can_be_unarchived?).to be_false
      end
    end



    it "returns true for archived applicants that have not been hired" do
      applicant = OpenStruct.new(
        name: 'Meagan',
        applied_on: Date.yesterday,
        discipline: 'developer',
        archived: true,
        hired: 'no',
        location: 'Chicago'
      )

      expect(ApplicantProfilePresenter.new(applicant).can_be_unarchived?).to be_true
    end
  end

  context "#can_be_denied?" do
    context 'non archived applicants' do
      let(:archived) { false }

      it "returns true" do
        expect(presenter.can_be_denied?).to be_true
      end
    end
    context 'archived applicants' do
      it "returns false" do
        expect(presenter.can_be_denied?).to be_false
      end
    end
  end
end

