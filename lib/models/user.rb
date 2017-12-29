require 'json'

module GoCLI
  class User
    attr_accessor :name, :email, :phone, :password

    # TODO:
    # 1. Add two instance variables: name and email
    # 2. Write all necessary changes, including in other files
    def initialize(opts = {})
      @name = opts[:name] || ''
      @email = opts[:email] || ''
      @phone = opts[:phone] || ''
      @password = opts[:password] || ''
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json")

      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json")
      data = JSON.parse(file)

      self.new(
        name:     data['name'],
        email:    data['email'],
        phone:    data['phone'],
        password: data['password']
      )
    end

    # TODO: Add your validation method here
    def validate
      error = []
      error << "Name can't be blank" if @name.empty?
      error << "Email can't be blank" if @email.empty?
      error << "Phone can't be blank" if @phone.empty?
      error << "Password can't be blank" if @password.empty?
      error << "Email format is invalid" if !is_valid_email?(@email)
      error << "Phone is not a number" if !is_numeric?(@phone)
      error << "Phone is too long (maximum is 12 characters)" if @phone.length > 12
      error << "Phone is too short (maximum is 10 characters)" if @phone.length < 10
      error << "Password is too short (minimum is 8 characters)" if @password.length < 8
      error
    end

    def save!
      # TODO: Add validation before writing user data to file
      user = {name: @name, email: @email, phone: @phone, password: @password}
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json", "w") do |f|
        f.write JSON.pretty_generate(user)
      end
    end

    private
     def is_numeric?(obj)
       obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
     end

     def is_valid_email?(obj)
        obj.to_s.match(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i) == nil ? false : true
     end
  end
end
