require_relative './models/user'
require_relative './models/location'
require_relative './models/order'
require_relative './models/driver'
require_relative './view'
require 'time'

module GoCLI
  # Controller is a class that call corresponding models and methods for every action
  class Controller
    # This is an example how to create a registration method for your controller
    def registration(opts = {})
      # First, we clear everything from the screen
      clear_screen(opts)

      # Second, we call our View and its class method called "registration"
      # Take a look at View class to see what this actually does
      form = View.registration(opts)

      # This is the main logic of this method:
      # - passing input form to an instance of User class (named "user")
      # - invoke ".save!" method to user object
      # TODO: enable saving name and email
      user = User.new(
        name:     form[:name],
        email:    form[:email],
        phone:    form[:phone],
        password: form[:password]
      )

      error = user.validate
      if error.empty?
        user.save!
        form[:flash_msg] = "Your account was successfully created"
      else
        form[:flash_msg] = ["Your account was not successfully created"]
        form[:flash_msg] << error
        registration(form)
      end

      # Assigning form[:user] with user object
      form[:user] = user

      # Returning the form
      form
    end

    def login(opts = {})
      halt = false
      while !halt
        clear_screen(opts)
        form = View.login(opts)

        # Check if user inputs the correct credentials in the login form
        if credential_match?(form[:user], form[:login], form[:password])
          halt = true
        else
          form[:flash_msg] = "Wrong login or password combination"
        end
      end

      return form
    end

    def main_menu(opts = {})
      clear_screen(opts)
      form = View.main_menu(opts)

      case form[:steps].last[:option].to_i
      when 1
        # Step 4.1
        view_profile(form)
      when 2
        # Step 4.2
        order_goride(form)
      when 3
        # Step 4.3
        view_order_history(form)
      when 4
        exit(true)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        main_menu(form)
      end
    end

    def view_profile(opts = {})
      clear_screen(opts)
      form = View.view_profile(opts)

      case form[:steps].last[:option].to_i
      when 1
        # Step 4.1.1
        edit_profile(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        view_profile(form)
      end
    end

    # TODO: Complete edit_profile method
    # This will be invoked when user choose Edit Profile menu in view_profile screen
    def edit_profile(opts = {})
      clear_screen(opts)
      form = View.edit_profile(opts)

      user = User.new(
        name:     form[:name],
        email:    form[:email],
        phone:    form[:phone],
        password: form[:password]
      )

      case form[:steps].last[:option].to_i
      when 1
        error = user.validate
        if error.empty?
          user.save!
          form[:user] = user
          form[:flash_msg] = "Your account was successfully updated"
          view_profile(form)
        else
          form[:flash_msg] = ["Your account was not successfully updated"]
          form[:flash_msg] << error
          view_profile(form)
        end
      when 2
        view_profile(form)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        edit_profile(form)
      end

      form
    end

    # TODO: Complete order_goride method
    def order_goride(opts = {})
      clear_screen(opts)
      form = View.order_goride(opts)

      order = Order.new(
        origin:     form[:origin],
        destination:form[:destination]
      )

      error = order.validate
      if error.empty?
        locations = Location.load
        origin = Location.find(form[:origin], locations)
        destination = Location.find(form[:destination], locations)

        if origin.nil?
          form[:flash_msg] = "Sorry, origin is not available!"
          main_menu(form)
        elsif destination.nil?
          form[:flash_msg] = "Sorry, destination is not available!"
          main_menu(form)
        else
          form[:origin_coord] = origin['coord']
          form[:destination_coord] = destination['coord']
          form[:est_price] = Order.calculate_est_price(form[:origin_coord], form[:destination_coord])
          order_goride_confirm(form)
        end
      else
        form[:flash_msg] = error
        order_goride(form)
      end
    end

    # TODO: Complete order_goride_confirm method
    # This will be invoked after user finishes inputting data in order_goride method
    def order_goride_confirm(opts = {})
      clear_screen(opts)
      form = View.order_goride_confirm(opts)

      case form[:steps].last[:option].to_i
      when 1
        drivers = Driver.load
        driver = Driver.find(form[:origin_coord], drivers)

        if driver.nil?
          form[:flash_msg] = "Sorry, your order was not successfully created.\nThe driver is busy"
        else
          order = Order.new(
            timestamp:    Time.now,
            origin:       form[:origin],
            destination:  form[:destination],
            est_price:    form[:est_price],
            driver:       driver['driver']
          )

          Driver.changes_coord(driver['driver'], form[:destination_coord])
          order.save!
          form[:order] = order
          form[:flash_msg] = "Your order was successfully created.\nThe driver is #{driver['driver']}"
        end
        main_menu(form)
      when 2
        order_goride(form)
      when 3
        main_menu(form)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        order_goride_confirm(form)
      end
    end

    def view_order_history(opts = {})
      clear_screen(opts)
      data = Order.load
      form = View.view_order_history(opts, data)

      case form[:steps].last[:option].to_i
      when 1
        main_menu(form)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        view_order_history(form)
      end

      form
    end

    protected
      # You don't need to modify this
      def clear_screen(opts = {})
        Gem.win_platform? ? (system "cls") : (system "clear")
        if opts[:flash_msg]
          puts opts[:flash_msg]
          puts ''
          opts[:flash_msg] = nil
        end
      end

      # TODO: credential matching with email or phone
      def credential_match?(user, login, password)
        return false unless user.phone == login || user.email == login
        return false unless user.password == password
        return true
      end
  end
end
