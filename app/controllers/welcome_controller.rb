class WelcomeController < ApplicationController
  def test
    # charge = PinPayment::Charge.create(
    #   email:       "test@gmail.com",
    #   amount:      0.1,
    #   currency:    'USD',
    #   description: 'Widgets',
    #   ip_address:  request.ip,
    #   card:        {
    #     number:           5520000000000000,
    #     expiry_month:     5,
    #     expiry_year:      2014,
    #     cvc:              123,
    #     name:             'Roland Robot',
    #     address_line1:    '42 Sevenoaks St',
    #     address_city:     'Lathlain',
    #     address_postcode: 6454,
    #     address_state:    'WA',
    #     address_country:  'Australia'
    #   }
    #   )
# PinPayment::Charge.create(
#   email:       'customer@email.com',
#   description: 'Widgets',
#   amount:      4999,
#   currency:    'USD',
#   card:        'card_nytGw7koRg23EEp9NTmz9w',
#   ip_address:  '1.2.3.4'
#   )



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
end

end