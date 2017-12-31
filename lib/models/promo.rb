require 'json'

module GoCLI
  class Promo
    def self.load
      data = []
      if File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/promo.json")
        file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/promo.json")
        data = JSON.parse(file)
      end
      data
    end

    def self.find(code, promo)
      promo.find { |p| p.has_value?(code) }
    end
  end
end
