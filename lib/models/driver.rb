# TODO: Complete Driver class
require 'json'

module GoCLI
	class Driver
		MAX_DIST_DRIVER = 1.0
		attr_accessor :driver, :coord, :service_type

		def initialize(opts = {})
			@driver = opts[:driver] || ''
			@coord = opts[:coord] || ''
			@service_type = opts[:service_type] || ''
		end

    def self.load
      data = []
      if File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json")
        file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json")
        data = JSON.parse(file)
      end
      data
    end

		def self.calculate_distance(origin, destination)
			distance = Math.sqrt(((destination.first - origin.first) ** 2) + ((destination.last - origin.last) ** 2)).to_f
      distance.round(2)
		end

    def self.find(origin, drivers)
      list_drivers = []
      drivers.each do |driver|
        distance = calculate_distance(origin, driver['coord'])
        list_drivers << driver if distance <= MAX_DIST_DRIVER
      end
      driver = list_drivers.shuffle!.first
    end

		def self.changes_coord(driver, coord)
			data = load
			data.each do |d|
				d['coord'] = coord if d['driver'] == driver
			end

			File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json", "w") do |f|
        f.write JSON.pretty_generate(data)
      end
		end
	end
end
