require 'dotenv/tasks'

namespace :fleetmon do

  desc "Import FleetMon MyVessel API"
  task import: :environment do
    unless ENV.has_key? 'FLEETMON_USER' and ENV.has_key? 'FLEETMON_KEY'
      puts "FLEETMON_USER and FLEETMON_KEY is required"
      return
    end

    fm_host = ENV['FLEETMON_HOST'] || 'www.fleetmon.com'
    fm_path = "/api/p/personal-v1/myfleet/?username=#{ENV['FLEETMON_USER']}&api_key=#{ENV['FLEETMON_KEY']}&format=json"
    response = Net::HTTP.get_response(fm_host,fm_path)
    data = JSON.parse response.body

    data['objects'].map { |o| o['vessel'] }.compact.each do |vessel|
      Rails.logger.info "Import #{vessel['name']} (#{vessel['mmsinumber']})"

      ship = Ship.find_by(:mmsi => vessel['mmsinumber'].to_s)
      unless ship
        Rails.logger.info "Ship not found"
        next
      end

      begin
        ShipPosition.create!([{
          mmsi: vessel['mmsinumber'],
          position: "POINT(#{vessel['longitude']} #{vessel['latitude']})",
          speed: vessel['speed'],
          course: vessel['heading'].to_f,
          status: nil,
          timestamp: vessel['positionreceived'],
          source: 'fleetmon',
        }])
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.info e.message
      rescue Exception => e
        Rails.logger.error e.message
        e.backtrace.each { |l| Rails.logger.error l }
      end

    end
  end

end
