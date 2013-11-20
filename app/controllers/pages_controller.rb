# coding:utf-8
# some useful API refs
# https://dashboard.pin.net.au/account
# https://pin.net.au/docs/api#endpoints
# https://github.com/dNitza/pin_up
# https://pin.net.au/docs/languages/ruby
# https://pin.net.au/docs/api/charges
class PagesController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:send_message, :do]

  def index
  end

  def plan
  end

  def buy
    type = params[:type]
    @price = if type == 'a'
      'free'
    elsif type == 'b'
      '99.95'
    elsif type == 'c'
      '149.95'
    elsif type == 'd'
      '209.95'
    end
  end

  def about
  end

  def contact
  end

  def send_message
    options = {
      "firstname" => params[:firstname],
      "lastname" => params[:lastname],
      "email" => params[:email],
      "subject" => params[:subject],
      "message" => params[:message]
    }
    begin
      UserMailer.send_message(options).deliver!
    rescue Exception => e
      Rails.logger.info %Q(#{e.message})
      Rails.logger.info %Q(#{e.backtrace.join("\n")})
      render :json => { code: 0, error: 'exception' } and return
    end
    render :json => { code: 1 }
  end

  # Parameters: {
  # "fname"=>"", "lname"=>"", "email"=>"", "phone"=>"", "company"=>"", "position"=>"", "website"=>"", "message"=>"", 
  # "card_name"=>"", "card_number"=>"", "month"=>"", "year"=>"", "cvv"=>"", "address"=>"", "city"=>"", "state"=>"", 
  # "zip_code"=>""
  # }
  def do
    # customer_details = {
    #   number: '5520000000000000',
    #   expiry_month: "12", 
    #   expiry_year: "2014", 
    #   cvc: "123", 
    #   name: 'Roland Robot',
    #   address_line1: '123 fake street', 
    #   address_city: 'Melbourne', 
    #   address_postcode: '1234', 
    #   address_state: 'Vic', 
    #   address_country: 'Australia'
    # }
    customer_details = {
      number: params[:card_number],
      expiry_month: params[:month], 
      expiry_year: params[:year], 
      cvc: params[:cvv], 
      name: params[:card_name],
      address_line1: params[:address], 
      address_city: params[:city], 
      address_postcode: params[:zip_code], 
      address_state: params[:state], 
      address_country: 'Australia'
    }
    begin
      customer = Pin::Customer.create('email@example.com', customer_details)
    rescue # Pin::InvalidResource
      render :json => { code: 0, error: 'card validate error, please check your billing information' } and return
    end
    Rails.logger.debug "debug customer #{customer.inspect}"
    token = customer['token']
    type = params[:type]
    fee = if type == "b"
      99.95
    elsif type == "c"
      149.95
    elsif type == 'd'
      209.95
    end
    if fee.nil?
      render :json => { code: 0, error: "no fee" } and return
    end
    charge_details = {
      email: params[:email], 
      description: params[:message], 
      amount: fee,
      currency: "AUD", 
      ip_address: request.ip,
      customer_token: token
    }
    charge = Pin::Charges.create(charge_details)
    Rails.logger.debug "debug charge #{charge.inspect}"
    if charge['success']
      begin
        UserMailer.buy(params).deliver!
      rescue
      end
      render :json => { code: 1 }
    else
      render :json => { code: 0, error: 'card charge error' }
    end
  end

end

