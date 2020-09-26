require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Answer best_assign' do
    let!(:answer) { create(:answer) }
    it 'assign the best for answer' do
      answer.best_assign
      expect(answer.best).to_not be_falsy
    end
  end

  describe 'Answer best change' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, best: false, question: question) }
    let!(:answer_1) { create(:answer, best: false, question: question) }
    it 'change the best for answer' do
      answer.best_assign
      answer_1.best_assign
      answer.reload
      answer_1.reload
      expect(answer.best).to be_falsy
      expect(answer_1.best).to_not be_falsy
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
