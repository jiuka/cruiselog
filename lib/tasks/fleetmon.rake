require 'dotenv/tasks'

namespace :fleetmon do

  desc "Import FleetMon MyVessel API"
  task import: :environment do
    unless ENV.has_key? 'FLEETMON_USER' and ENV.has_key? 'FLEETMON_KEY'
      puts "FLEETMON_USER and FLEETMON_KEY is required"
      return
    end

    # Prepare Logger
    pos_logger ||= Logger.new("#{Rails.root}/log/import_fleetmon.log")

    fm_host = ENV['FLEETMON_HOST'] || 'www.fleetmon.com'
    fm_path = "/api/p/personal-v1/myfleet/?username=#{ENV['FLEETMON_USER']}&api_key=#{ENV['FLEETMON_KEY']}&format=json"
    response = Net::HTTP.get_response(fm_host,fm_path)
    data = JSON.parse response.body

    data['objects'].map { |o| o['vessel'] }.compact.each do |vessel|
      print "Import #{vessel['name']} (#{vessel['mmsinumber']})"

      ship = Ship.find_by(:mmsi => vessel['mmsinumber'].to_s)
      unless ship
        puts " not found"
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
      rescue
        puts " failed"
      else
        puts " inserted"
      end

    end
  end

end
