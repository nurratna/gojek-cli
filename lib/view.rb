module GoCLI
  # View is a class that show menus and forms to the screen
  class View
    # This is a class method called ".registration"
    # It receives one argument, opts with default value of empty hash
    # TODO: prompt user to input name and email
    def self.registration(opts = {})
      form = opts

      puts 'Registration'
      puts ''

      print "Your name\t: "
      form[:name] = gets.chomp

      print "Your email\t: "
      form[:email] = gets.chomp

      print "Your phone\t: "
      form[:phone] = gets.chomp

      print "Your password\t: "
      form[:password] = gets.chomp

      form[:steps] << {id: __method__}

      form
    end

    def self.login(opts = {})
      form = opts

      puts 'Login'
      puts ''

      print "Enter your email/phone\t: "
      form[:login] = gets.chomp

      print "Enter your password\t: "
      form[:password] = gets.chomp

      form[:steps] << {id: __method__}

      form
    end

    def self.main_menu(opts = {})
      form = opts

      puts 'Welcome to Go-CLI!'
      puts ''

      puts 'Main Menu'
      puts '1. View Profile'
      puts '2. Order Go-Ride'
      puts '3. View Order History'
      puts '4. Exit'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end

    # TODO: Complete view_profile method
    def self.view_profile(opts = {})
      form = opts

      puts 'View Profile'
      puts ''

      # Show user data here
      user = form[:user]
      puts "Name\t: #{user.name}"
      puts "Email\t: #{user.email}"
      puts "Phone\t: #{user.phone}"
      puts "Password: #{user.password}"
      puts ''

      puts '1. Edit Profile'
      puts '2. Back'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end

    # TODO: Complete edit_profile method
    # This is invoked if user chooses Edit Profile menu when viewing profile
    def self.edit_profile(opts = {})
      form = opts

      puts 'Edit Profile'
      puts ''

      print "Your name\t: "
      form[:name] = gets.chomp

      print "Your email\t: "
      form[:email] = gets.chomp

      print "Your phone\t: "
      form[:phone] = gets.chomp

      print "Your password\t: "
      form[:password] = gets.chomp

      puts ''
      puts '1. Save'
      puts '2. Back'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end

    # TODO: Complete order_goride method
    def self.order_goride(opts = {})
    end

    # TODO: Complete order_goride_confirm method
    # This is invoked after user finishes inputting data in order_goride method
    def self.order_goride_confirm(opts = {})
    end

    # TODO: Complete view_order_history method
    def self.view_order_history(opts = {})
    end
  end
end
