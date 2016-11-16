shared_examples 'ratable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  describe "#show_rate" do
    before { 5.times {create(:rating, ratings: 1, ratable: model, user: create(:user)) } }
    before { 2.times {create(:rating, ratings: -1, ratable: model, user: create(:user)) } }

    it { expect(model.show_rate).to eq(3) }
  end

  describe "#rate_up" do
    let(:user2) { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    context "rate up another user answer/post" do
      it { expect{ model.rate_up(user2) }.to change{ model.show_rate }.by(1) }
    end

    context "rate up his answer/post" do
      it { expect{ model.rate_up(user) }.to_not change{ model.show_rate } }
    end
  end

  describe "#rate_down" do
    let(:user2) { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    context "rate down another user answer/post" do
      it { expect{ model.rate_down(user2) }.to change{ model.show_rate }.by(-1) }
    end

    context "rate down his answer/post" do
      it { expect { model.rate_down(user) }.to_not change{ model.show_rate} }
    end
  end

  describe "#has_minus_rate?" do
    context "rate have minus rate" do
      before { create(:rating, ratings: -1, ratable: model, user: user) }

      it { expect(model).to have_minus_rate(user) }
    end
    context "rate have not minus rate" do
      before { create(:rating, ratings: 1, ratable: model, user: user) }

      it { expect(model).to_not have_minus_rate(user) }
    end
  end

  describe "#has_plus_rate?" do
    context "rate have plus rate" do
      before { create(:rating, ratings: 1, ratable: model, user: user) }

      it { expect(model).to have_plus_rate(user) }
    end
    context "rate have not minus rate" do
      before { create(:rating, ratings: -1, ratable: model, user: user) }

      it { expect(model).to_not have_plus_rate(user) }
    end
  end
end
