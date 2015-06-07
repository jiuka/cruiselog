require 'rails_helper'

RSpec.describe IstNalaAufKreuzfahrtController, type: :controller do

  describe "GET index" do
    it 'redirects to :leider_noch_nicht' do
      create(:cruise, start_at: Time.now+1.day, end_at: Time.now+10.days)
      expect(get :index).to redirect_to :action => :index, :status => :leider_noch_nicht
    end

    it 'does not redirect loop to :leider_noch_nicht' do
      create(:cruise, start_at: Time.now+1.day, end_at: Time.now+10.days)
      expect(get :index, :status => 'leider_noch_nicht').to render_template(:index)
    end

    it 'redirects to :ja' do
      create(:cruise, start_at: Time.now-1.day, end_at: Time.now+10.days)
      expect(get :index).to redirect_to :action => :index, :status => :ja
    end

    it 'does not redirect loop to :ja' do
      create(:cruise, start_at: Time.now-1.day, end_at: Time.now+10.days)
      expect(get :index, :status => 'ja').to render_template(:index)
    end

    it 'redirects to :nicht_mehr_lange' do
      create(:cruise, start_at: Time.now-10.day, end_at: Time.now+0.5.days)
      expect(get :index).to redirect_to :action => :index, :status => :nicht_mehr_lange
    end

    it 'does not redirect loop to :nicht_mehr_lange' do
      create(:cruise, start_at: Time.now-10.day, end_at: Time.now+0.5.days)
      expect(get :index, :status => 'nicht_mehr_lange').to render_template(:index)
    end

    it 'redirects to :leider_nicht_mehr' do
      create(:cruise, start_at: Time.now-10.day, end_at: Time.now-1.days)
      expect(get :index).to redirect_to :action => :index, :status => :leider_nicht_mehr
    end

    it 'does not redirect loop to :leider_nicht_mehr' do
      create(:cruise, start_at: Time.now-10.day, end_at: Time.now-1.days)
      expect(get :index, :status => 'leider_nicht_mehr').to render_template(:index)
    end
  end

  describe "GET index.json" do
    it 'does not redirect to :leider_noch_nicht' do
      create(:cruise, start_at: Time.now+1.day, end_at: Time.now+10.days)
      get :index, format: :json
      expect(response.status).to eq(200)
    end
  end

end
