require 'uri'
require 'net/http'

require 'dotenv/tasks'

namespace :marine_traffic do

  desc 'Import from exportvessels API'
  task :import_vessels => :environment do

    begin
      uri = URI("http://services.marinetraffic.com/api/exportvessels/#{ENV['MARINE_TRAFFIC_EXPORTVESSEL_APIKEY']}/timespan:30/protocol:json")

      data = Net::HTTP.get(uri)

      points = JSON.parse data
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
    end

    points.each do |point|
      begin
        ShipPosition.create!([{
          mmsi: point[0],
          position: "POINT(#{point[2]} #{point[1]})",
          speed: point[3]/10,
          course: point[4],
          status: point[5],
          timestamp: point[6],
          source: 'marinetraffic',
        }])
      rescue Exception => e
        Rails.logger.error e.message
        e.backtrace.each { |l| Rails.logger.error l }
      end
    end
  end

end
