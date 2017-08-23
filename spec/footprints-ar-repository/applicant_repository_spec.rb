require 'spec_helper'
require './lib/ar_repository/applicant_repository'
require './spec/footprints/shared_examples/applicant_examples'

describe ArRepository::ApplicantRepository do

  it_behaves_like "applicant repository"

  context 'pagination' do

    before do
      create_list(:applicant, 13, archived: archived)
    end

    describe '#get_all_archived_applicants' do
      let(:archived) { true }

      it 'paginates properly' do
        expect(subject.get_all_archived_applicants(1, 12).length).to eq 12
        expect(subject.get_all_archived_applicants(2, 12).length).to eq 1
      end
    end

    describe '#get_all_unarchived_applicants' do
      let(:archived) { false }

      it 'paginates properly' do
        expect(subject.get_all_unarchived_applicants(1, 12).length).to eq 12
        expect(subject.get_all_unarchived_applicants(2, 12).length).to eq 1
      end
    end
  end
end
