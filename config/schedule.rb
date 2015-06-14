# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

if @environment == 'production'
  every 3.minutes do
    rake "marine_traffic:import_vessels"
  end

  every 10.minutes do
    rake "fleetmon:import"
  end
end

# Learn more: http://github.com/javan/whenever
