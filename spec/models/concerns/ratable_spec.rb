require 'rails_helper'

shared_examples 'ratable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe "#show_rate" do

  end
end
