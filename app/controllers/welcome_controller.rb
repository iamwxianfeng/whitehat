class WelcomeController < ApplicationController
  def test
    customer_details = {
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

    render :text =>  Pin::Customer.create('email@example.com', customer_details)
    # return
    # {"token"=>"cus_Wk539RchWnZk2Ljf0m7ubQ", "email"=>"email@example.com", "created_at"=>"2013-11-02T08:25:43Z", "card"=>{"token"=>"card__9VZ1om8uyeH86VoKSXneQ", "scheme"=>"master", "display_number"=>"XXXX-XXXX-XXXX-0000", "expiry_month"=>12, "expiry_year"=>2014, "name"=>"Roland Robot", "address_line1"=>"123 fake street", "address_line2"=>nil, "address_city"=>"Melbourne", "address_postcode"=>"1234", "address_state"=>"Vic", "address_country"=>"Australia"}}
  end

  def test1
    charge = {
      email: "email@example.com", 
      description: "Description", 
      amount: "100",
      currency: "AUD", 
      ip_address: "127.0.0.1", 
      customer_token: "cus_Wk539RchWnZk2Ljf0m7ubQ" 
    }

  # Pin::InvalidResource (card_invalid: Card can't be blankamount_invalid: Amount must be more than 100 (AUD$1.00)):

  render :text => Pin::Charges.create(charge)
  # return
  # {"token"=>"ch_8V4Mt3exKmLS0yRQ2Z5lkg", "success"=>true, "amount"=>100, "currency"=>"AUD", "description"=>"Description", "email"=>"email@example.com", "ip_address"=>"127.0.0.1", "created_at"=>"2013-11-02T08:27:30Z", "status_message"=>"Success", "error_message"=>nil, "card"=>{"token"=>"card__9VZ1om8uyeH86VoKSXneQ", "scheme"=>"master", "display_number"=>"XXXX-XXXX-XXXX-0000", "expiry_month"=>12, "expiry_year"=>2014, "name"=>"Roland Robot", "address_line1"=>"123 fake street", "address_line2"=>nil, "address_city"=>"Melbourne", "address_postcode"=>"1234", "address_state"=>"Vic", "address_country"=>"Australia"}, "transfer"=>[], "amount_refunded"=>0, "total_fees"=>33, "merchant_entitlement"=>67, "refund_pending"=>false, "authorisation_expired"=>false, "captured"=>true}
end

end