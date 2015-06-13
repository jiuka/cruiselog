class IstNalaAufKreuzfahrtController < ApplicationController

  def default_url_options
    if Rails.env.production?
      { domain: 'dev.istnalaaufkreuzfahrt.ch' , subdomain: nil}
    else
      { host: "#{Rails.env}.istnalaaufkreuzfahrt.ch" }
    end
  end

  MESSAGES = {
    leider_noch_nicht: 'Leider noch nicht, erst in:',
    ja: 'Ja, seit:',
    nicht_mehr_lange: 'Nur noch:',
    leider_nicht_mehr: 'Leider nicht mehr seit:'
  }

  # GET /cruises
  # GET /cruises.json
  def index
    @cruise = Cruise.where('end_at > ? ', Time.now-5.days).order(:start_at).first

    if @cruise.start_at > Time.now
      @status = :leider_noch_nicht
      @date = @cruise.start_at
    elsif @cruise.end_at > Time.now+1.day
      @status = :ja
      @date = @cruise.start_at
    elsif @cruise.end_at > Time.now
      @status = :nicht_mehr_lange
      @date = @cruise.end_at
    else
      @status = :leider_nicht_mehr
      @date = @cruise.end_at
    end

    @message = MESSAGES[@status]

    if params[:status] != @status.to_s
      respond_to do |format|
        format.html { redirect_to ist_nala_auf_kreuzfahrt_status_url(status: @status) }
        format.json { render }
      end
    end
  end

end
