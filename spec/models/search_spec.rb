require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    %w(Questions Answers Comments Users).each do |obj|
      it "Array of #{obj}" do
        expect(ThinkingSphinx).to receive(:search).with('Request', classes: [obj.singularize.classify.constantize])
        Search.perform('Request', "#{obj}")
      end
    end

    it "Anything object" do
      expect(ThinkingSphinx).to receive(:search).with('Request')
      Search.perform('Request', 'All')
    end

    it "Invalid condition" do
      result = Search.perform('Request', 'Nonexistent')
      expect(result).to be_nil
    end
  end
end
