require 'uri'
require 'net/http'

require 'dotenv/tasks'

namespace :marine_traffic do

  desc 'Import from exportvessels API'
  task :import_vessels => :environment do

    begin
      uri = URI("http://services.marinetraffic.com/api/exportvessels/#{ENV['MARINE_TRAFFIC_EXPORTVESSEL_APIKEY']}/timespan:30/protocol:xml")

      data = Net::HTTP.get(uri)

      rows = Nokogiri::XML(data).xpath("//row")
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
    end

    rows.each do |row|
      begin
        ShipPosition.create!([{
          mmsi: row.attr('MMSI'),
          position: "POINT(#{row.attr('LON')} #{row.attr('LAT')})",
          speed: row.attr('SPEED').to_f/10,
          heading: row.attr('HEADING'),
          course: row.attr('COURSE'),
          status: row.attr('STATUS'),
          timestamp: row.attr('TIMESTAMP'),
          source: 'marinetraffic',
        }])
      rescue Exception => e
        Rails.logger.error e.message
        e.backtrace.each { |l| Rails.logger.error l }
      end
    end
  end

end
