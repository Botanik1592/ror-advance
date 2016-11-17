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

    context "rate up another user answer/post" do
       it { expect{ model.rate_up(user2) }.to change{ model.show_rate }.by(1) }

       it { expect(model.rate_up(user2)).to eq model.ratings.first }
    end

    context "rate up his answer/post" do
      it { expect{ model.rate_up(user) }.to_not change{ model.show_rate } }

      it { expect(model.rate_up(user)).to eq [true, "You can't vote for this!"] }
    end

    context "rate up when rate_up already exists" do
      before { create(:rating, ratings: 1, ratable: model, user: user2) }

      it { expect{ model.rate_up(user2) }.to_not change{ model.show_rate} }

      it { expect(model.rate_up(user2)).to eq [true, "You can't vote for this!"] }
    end

    context "rate up when rate_down already exists" do
      before { create(:rating, ratings: -1, ratable: model, user: user2) }

      it { expect{ model.rate_up(user2) }.to change{ model.show_rate}.by(2) }

      it { expect(model.rate_up(user2)).to eq model.ratings.first }
    end
  end

  describe "#rate_down" do
    let(:user2) { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    context "rate down another user answer/post" do
      it { expect{ model.rate_down(user2) }.to change{ model.show_rate }.by(-1) }

      it { expect(model.rate_down(user2)).to eq model.ratings.first }
    end

    context "rate down his answer/post" do
      it { expect { model.rate_down(user) }.to_not change{ model.show_rate} }

      it { expect(model.rate_down(user)).to eq [true, "You can't vote for this!"] }
    end

    context "rate down when rate_down already exists" do
      before { create(:rating, ratings: -1, ratable: model, user: user2) }

      it { expect{ model.rate_down(user2) }.to_not change{ model.show_rate} }

      it { expect(model.rate_down(user2)).to eq [true, "You can't vote for this!"] }
    end

    context "rate down when rate_up already exists" do
      before { create(:rating, ratings: 1, ratable: model, user: user2) }

      it { expect{ model.rate_down(user2) }.to change{ model.show_rate}.by (-2) }

      it { expect(model.rate_down(user2)).to eq model.ratings.first }
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
