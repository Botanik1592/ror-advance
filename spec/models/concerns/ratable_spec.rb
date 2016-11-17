shared_examples 'ratable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  describe "#show_rate" do
    it "show rate of answe/question" do
      create_list(:rating, 5, ratings: 1, ratable: model)
      create_list(:rating, 2, ratings: -1, ratable: model)

      expect(model.show_rate).to eq(3)
    end
  end

  describe "#rate_up" do
    let(:user2) { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    it "rate up another user answer/post" do
       expect{ model.rate_up(user2) }.to change{ model.show_rate }.by(1)
    end

    it "rate up his answer/post" do
      expect{ model.rate_up(user) }.to_not change{ model.show_rate }
    end

    context "rate up when rate_up already exists" do
      before { create(:rating, ratings: 1, ratable: model, user: user2) }

      it { expect{ model.rate_up(user2) }.to_not change{ model.show_rate} }

      it { expect(model.rate_up(user2)).to include("You can't vote for this!") }
    end

    context "rate up when rate_down already exists" do
      before { create(:rating, ratings: -1, ratable: model, user: user2) }

      it { expect{ model.rate_up(user2) }.to change{ model.show_rate}.by (2) }
    end

    it "send 'You can't vote for this!' if user rate_up his answer/post" do
      expect(model.rate_up(user)).to include("You can't vote for this!")
    end


  end

  describe "#rate_down" do
    let(:user2) { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    it "rate down another user answer/post" do
      expect{ model.rate_down(user2) }.to change{ model.show_rate }.by(-1)
    end

    it "rate down his answer/post" do
      expect { model.rate_down(user) }.to_not change{ model.show_rate}
    end

    context "rate down when rate_down already exists" do
      before { create(:rating, ratings: -1, ratable: model, user: user2) }

      it { expect{ model.rate_down(user2) }.to_not change{ model.show_rate} }

      it { expect(model.rate_down(user2)).to include("You can't vote for this!") }
    end

    context "rate down when rate_up already exists" do
      before { create(:rating, ratings: 1, ratable: model, user: user2) }

      it { expect{ model.rate_down(user2) }.to change{ model.show_rate}.by (-2) }
    end

    it "send 'You can't vote for this!' if user rate_up his answer/post" do
      expect(model.rate_down(user)).to include("You can't vote for this!")
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
