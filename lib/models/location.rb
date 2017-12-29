# TODO: Complete Location class
require 'json'

module GoCLI
  class Location
    def self.load
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json")
      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json")
      data = JSON.parse(file)
    end

    def self.find(name_of_location)
      locations = load
      location = locations.find { |location| location.has_value?(name_of_location) }
    end
  end
end
