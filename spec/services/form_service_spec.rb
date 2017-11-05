require 'spec_helper'

describe ::FormService do
  describe '#fields_for_form_type' do
    it 'returns only the fields for the specified form type' do
      expect(::Field).to receive(:where).with(form_type: 'application')

      described_class.fields_for_form_type('application')
    end
  end
end
