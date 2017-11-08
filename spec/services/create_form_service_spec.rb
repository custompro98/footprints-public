require 'spec_helper'

describe ::CreateFormService do
  it 'saves the field to the database' do
    described_class.create_form('application', 1 => {name: 'Field Name'})

    expect(Field.first.name).to eq 'Field Name'
  end

  it 'doesnt save the field if the name is blank' do
    described_class.create_form('application', 1 => {name: ''})

    expect(Field.first).to be nil
  end

  context 'the field has no answer data' do
    it 'saves the field as open text' do
      described_class.create_form('application', 1 => {name: 'Field Name'})

      expect(Field.first.has_choices).to be false
    end
  end

  context 'the field has answer data' do
    it 'saves the field as a defined answer type' do
      described_class.create_form('application', 1 => {name: 'Field Name', answers: {1 => {name: 'Answer 1'}}})

      expect(Field.first.has_choices?).to be true
    end

    it 'saves the field choice' do
      described_class.create_form('application', 1 => {name: 'Field Name', answers: {1 => {name: 'Answer 1'}}})

      expect(FieldChoice.first.name).to eq 'Answer 1'
    end

    context 'the field choice name is blank' do
      it 'doesnt save a field choice if its name is blank' do
        described_class.create_form('application', 1 => {name: 'Field Name', answers: {1 => {name: ''}}})

        expect(FieldChoice.first).to be nil
      end

      it 'saves the field as open text if the answers are all blank' do
        described_class.create_form('application', 1 => {name: 'Field Name', answers: {1 => {name: ''}}})

        expect(Field.first.has_choices).to be false
      end
    end
  end
end
