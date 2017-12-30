# TODO: Complete Order class
require 'json'
require 'time'

module GoCLI
  class Order
    GORIDE_PER_KM = 1500
    attr_accessor :timestamp, :origin, :destination, :est_price, :driver

    def initialize(opts = {})
      @timestamp = opts[:timestamp] || ''
			@origin = opts[:origin] || ''
			@destination = opts[:destination] || ''
			@est_price = opts[:est_price] || ''
      @driver = opts[:driver] || ''
    end

    def self.load
      data = []
      if File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json")
        file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json")
        data = JSON.parse(file)
      end
      data
    end

    def validate
      error = []
      error << "Origin can't be blank" if @origin.empty?
      error << "Destination can't be blank" if @destination.empty?
      error << "Origin and Destination can't be same" if @origin == @destination
      error
    end

    def self.calculate_est_price(origin, destination)
      cost = 0
      distance = Math.sqrt(((destination.first - origin.first) ** 2) + ((destination.last - origin.last) ** 2)).to_f
      cost = distance.round(2) * GORIDE_PER_KM
      cost
    end

    def save!
      order = {timestamp: @timestamp, origin: @origin, destination: @destination, est_price: @est_price, driver: @driver}
      data = Order.load
      data << order
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json", "w") do |f|
        f.write JSON.pretty_generate(data)
      end
    end
  end
end
