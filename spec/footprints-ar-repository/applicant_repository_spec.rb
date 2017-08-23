require 'spec_helper'
require './lib/ar_repository/applicant_repository'
require './spec/footprints/shared_examples/applicant_examples'

describe ArRepository::ApplicantRepository do
  let(:subject) {described_class.new}

  it_behaves_like "applicant repository"

  it 'paginates properly' do
     create_list(:applicant, 13, archived: true)
     expect(subject.get_all_archived_applicants(1, 12).size).to eq 12
     expect(subject.get_all_archived_applicants(2, 12).size).to eq 1
  end

end
