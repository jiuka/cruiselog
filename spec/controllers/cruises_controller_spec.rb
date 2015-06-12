require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CruisesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Cruise. As you add validations to Cruise, be sure to
  # adjust the attributes here as well.
  let(:ship) { create(:ship) }
  let(:valid_attributes) {
    { name: 'Cruise Name', ship_id: ship.id, start_at: DateTime.now, end_at: DateTime.now+7.days }
  }

  let(:invalid_attributes) {
    { name: 'Cruise Name', ship: nil, start_at: DateTime.now, end_at: DateTime.now-7.days }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CruisesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "redirects to current cruise" do
      cruise = create(:cruise, start_at: DateTime.now-1.day, end_at: DateTime.now+7.days)
      get :index, {}, valid_session
      expect(subject).to redirect_to action: 'show', id: cruise.friendly_id
    end
    it "redirects to Home" do
      cruise = create(:cruise, start_at: DateTime.now+1.day, end_at: DateTime.now+7.days)
      get :index, {}, valid_session
      expect(subject).to redirect_to controller: 'zuhause', action: 'index'
    end
  end

  describe "GET #show" do
    it "assigns the requested cruise as @cruise" do
      cruise = Cruise.create! valid_attributes
      get :show, {:id => cruise.to_param}, valid_session
      expect(assigns(:cruise)).to eq(cruise)
    end
  end

  describe "GET #new" do
    context 'as anonymous' do
      it 'requires login' do
        get :new, {}, valid_session
        expect(subject).to deny_access
      end
    end

    context 'as user' do
      before { sign_in }

      it "assigns a new cruise as @cruise" do
        get :new, {}, valid_session
        expect(assigns(:cruise)).to be_a_new(Cruise)
      end
    end
  end

  describe "GET #edit" do
    context 'as anonymous' do
      it 'requires login' do
        cruise = Cruise.create! valid_attributes
        get :edit, {:id => cruise.to_param}, valid_session
        expect(subject).to deny_access
      end
    end

    context 'as user' do
      before { sign_in } 

      it "assigns the requested cruise as @cruise" do
        cruise = Cruise.create! valid_attributes
        get :edit, {:id => cruise.to_param}, valid_session
        expect(assigns(:cruise)).to eq(cruise)
      end
    end
  end

  describe "POST #create" do
    context 'as anonymous' do
      it 'requires login' do
        post :create, {:cruise => valid_attributes}, valid_session
        expect(subject).to deny_access
      end
    end

    context 'as user' do
      before { sign_in } 

      context "with valid params" do
        it "creates a new Cruise" do
          expect {
            post :create, {:cruise => valid_attributes}, valid_session
          }.to change(Cruise, :count).by(1)
        end

        it "assigns a newly created cruise as @cruise" do
          post :create, {:cruise => valid_attributes}, valid_session
          expect(assigns(:cruise)).to be_a(Cruise)
          expect(assigns(:cruise)).to be_persisted
        end

        it "redirects to the created cruise" do
          post :create, {:cruise => valid_attributes}, valid_session
          expect(response).to redirect_to(Cruise.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved cruise as @cruise" do
          post :create, {:cruise => invalid_attributes}, valid_session
          expect(assigns(:cruise)).to be_a_new(Cruise)
        end

        it "re-renders the 'new' template" do
          post :create, {:cruise => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "PUT #update" do
    context 'as anonymous' do
      it 'requires login' do
        cruise = Cruise.create! valid_attributes
        put :update, {:id => cruise.to_param, :cruise => {}}, valid_session
        expect(subject).to deny_access
      end
    end

    context 'as user' do
      before { sign_in }

      context "with valid params" do
        let(:new_attributes) {
          { description: 'TESTDESC' }
        }

        it "updates the requested cruise" do
          cruise = Cruise.create! valid_attributes
          put :update, {:id => cruise.to_param, :cruise => new_attributes}, valid_session
          cruise.reload
          expect(cruise.description).to eq('TESTDESC')
        end

        it "assigns the requested cruise as @cruise" do
          cruise = Cruise.create! valid_attributes
          put :update, {:id => cruise.to_param, :cruise => valid_attributes}, valid_session
          expect(assigns(:cruise)).to eq(cruise)
        end

        it "redirects to the cruise" do
          cruise = Cruise.create! valid_attributes
          put :update, {:id => cruise.to_param, :cruise => valid_attributes}, valid_session
          expect(response).to redirect_to(cruise)
        end
      end

      context "with invalid params" do
        it "assigns the cruise as @cruise" do
          cruise = Cruise.create! valid_attributes
          put :update, {:id => cruise.to_param, :cruise => invalid_attributes}, valid_session
          expect(assigns(:cruise)).to eq(cruise)
        end

        it "re-renders the 'edit' template" do
          cruise = Cruise.create! valid_attributes
          put :update, {:id => cruise.to_param, :cruise => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context 'as anonymous' do
      it 'requires login' do
        cruise = Cruise.create! valid_attributes
        delete :destroy, {:id => cruise.to_param}, valid_session
        expect(subject).to deny_access
      end
    end

    context 'as user' do
      before { sign_in }

      it "destroys the requested cruise" do
        cruise = Cruise.create! valid_attributes
        expect {
          delete :destroy, {:id => cruise.to_param}, valid_session
        }.to change(Cruise, :count).by(-1)
      end
  
      it "redirects to the cruises list" do
        cruise = Cruise.create! valid_attributes
        delete :destroy, {:id => cruise.to_param}, valid_session
        expect(response).to redirect_to(cruises_url)
      end
    end
  end

end
