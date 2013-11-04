# coding:utf-8
# some useful API refs
# https://dashboard.pin.net.au/account
# https://pin.net.au/docs/api#endpoints
# https://github.com/dNitza/pin_up
# https://pin.net.au/docs/languages/ruby
# https://pin.net.au/docs/api/charges
class PagesController < ApplicationController

  def index
  end

  def plan
  end

  def buy
  end

  def about
  end

  def contact
  end

  # Parameters: {"fname"=>"", "lname"=>"", "email"=>"", "phone"=>"", "company"=>"", "position"=>"", "website"=>"", "message"=>"", 
  # "card_name"=>"", "card_number"=>"", "month"=>"", "year"=>"", "cvv"=>"", "address"=>"", "city"=>"", "state"=>"", "zip_code"=>""}
  def do
    customer_details = {
      # number: params[:card_number],
      number: '5520000000000000',
      expiry_month: "12", 
      expiry_year: "2014", 
      cvc: "123", 
      name: 'Roland Robot',
      address_line1: '123 fake street', 
      address_city: 'Melbourne', 
      address_postcode: '1234', 
      address_state: 'Vic', 
      address_country: 'Australia'
    }
    begin
      customer = Pin::Customer.create('email@example.com', customer_details)
    rescue Pin::InvalidResource
      render :json => { code: 0, error: 'card validate error' } and return
    end
    Rails.logger.debug "debug customer #{customer.inspect}"
    token = customer['token']
    charge_details = {
      email: "email@example.com", 
      description: "Description", 
      amount: "100",
      currency: "AUD", 
      ip_address: "127.0.0.1", 
      customer_token: token
    }
    charge = Pin::Charges.create(charge_details)
    Rails.logger.debug "debug charge #{charge.inspect}"
    if charge['success']
      UserMailer.buy(params).deliver!
      render :json => { code: 1 }
    else
      render :json => { code: 0, error: 'card charge error' }
    end
  end

end

