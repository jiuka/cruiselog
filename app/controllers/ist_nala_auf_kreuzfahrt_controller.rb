class IstNalaAufKreuzfahrtController < ApplicationController
  before_filter :set_locale

  def default_url_options
    if Rails.env.production?
      { domain: 'dev.istnalaaufkreuzfahrt.ch' , subdomain: nil}
    else
      { host: "#{Rails.env}.istnalaaufkreuzfahrt.ch" }
    end
  end

  # GET /cruises
  # GET /cruises.json
  def index
    @cruise = Cruise.where('end_at > ? ', Time.now-5.days).order(:start_at).first

    if @cruise.start_at > Time.now
      @message = t('.leider_noch_nicht')
      @status = t('.status.leider_noch_nicht')
      @date = @cruise.start_at
    elsif @cruise.end_at > Time.now+1.day
      @message = t('.ja')
      @status = t('.status.ja')
      @date = @cruise.start_at
    elsif @cruise.end_at > Time.now
      @message = t('.nicht_mehr_lange')
      @status = t('.status.nicht_mehr_lange')
      @date = @cruise.end_at
    else
      @message = t('.leider_nicht_mehr')
      @status = t('.status.leider_nicht_mehr')
      @date = @cruise.end_at
    end

    if params[:status] != @status.to_s
      respond_to do |format|
        format.html { redirect_to ist_nala_auf_kreuzfahrt_status_url(status: @status.to_s) }
        format.json { render }
      end
    end
  end

  private
    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end

end
