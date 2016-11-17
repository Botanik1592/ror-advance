shared_examples 'rated' do
  describe 'PATCH #rate_up' do
    sign_in_user

    let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

    let(:params) do {
        id: model.id, format: :json
      }
    end

    context "Rate at another post/answer" do
      it "assigns the answer/post to @ratable" do
        patch :rate_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "rate up answer/post" do
        expect { patch :rate_up, params: params }.to change{ model.ratings.where(user: @user).sum(:ratings) }.by(1)
      end
   end

    context "Rate at own post/answer" do
      let(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }

      it "assigns the answer/post to @ratable" do
        patch :rate_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "does not rate up answer/post" do
        expect { patch :rate_up, params: params }.to_not change { model.ratings.where(user: @user).sum(:ratings) }
      end
    end

    context "Post/answer already have rate up" do

      before { model.ratings.create(user: @user, ratings: 1) }

      it "assigns the answer/post to @ratable" do
        patch :rate_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "does not rate up answer/post" do
        expect { patch :rate_up, params: params }.not_to change{ model.ratings.where(user: @user) }
      end
    end

    context "Post/answer already have rate down" do

      before { model.ratings.create(user: @user, ratings: -1) }

      it "assigns the answer/post to @ratable" do
        patch :rate_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "Change answer/post ratings by 2" do
        expect { patch :rate_up, params: params }.to change{ model.ratings.where(user: @user).sum(:ratings) }.by(2)
      end
    end
  end

  describe 'PATCH #rate_down' do
    sign_in_user

    let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

    let(:params) do {
        id: model.id, format: :json
      }
    end

    context "Rate at another post/answer" do
      it "assigns the answer/post to @ratable" do
        patch :rate_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "rate down answer/post" do
        expect { patch :rate_down, params: params }.to change{ model.ratings.where(user: @user).sum(:ratings) }.by(-1)
      end
   end

    context "Rate at own post/answer" do
      let(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }

      it "assigns the answer/post to @ratable" do
        patch :rate_down, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "does not rate down answer/post" do
        expect { patch :rate_down, params: params }.to_not change { model.ratings.where(user: @user).sum(:ratings) }
      end
    end

    context "Post/answer already have rate down" do

      before { model.ratings.create(user: @user, ratings: -1) }

      it "assigns the answer/post to @ratable" do
        patch :rate_down, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "does not rate down answer/post" do
        expect { patch :rate_down, params: params }.not_to change{ model.ratings.where(user: @user) }
      end
    end

    context "Post/answer already have rate up" do

      before { model.ratings.create(user: @user, ratings: 1) }

      it "assigns the answer/post to @ratable" do
        patch :rate_down, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "Change answer/post ratings by 2" do
        expect { patch :rate_down, params: params }.to change{ model.ratings.where(user: @user).sum(:ratings) }.by(-2)
      end
    end
  end
end
