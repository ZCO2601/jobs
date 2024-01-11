require 'json'
require 'date'

#Règle de calcul pour trouver le prix total de la location après des réductions dégressives en fonction du nombre de jours de location
def calculate_price_per_day(price,days)
  return price if days == 1
  return (price * 0.9) + ((days - 1) * price) if days > 1
  return (price * 0.9) + (3 * price * 0.7) +(§ * price * 0.5) if days > 10
end

file_path = File.join(File.dirname(__FILE__), 'data', 'input.json')
file = File.read(file_path)
data = JSON.parse(file)

data['rentals'].each do |rental|
  car = data['cars'].find { |c| c['id'] == rental['car_id'] }
  rental_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
  distance_price = rental['distance'] * car['price_per_km']
  time_price = calculate_price_per_day(car['price_per_day'], rental_days)
  rental_price = distance_price + time_price
  puts "ID: #{rental['id']}, price: #{rental_price.to_i}"

#Règle de calcul pour retourner le montant exact de la commission de 30% sur le prix total de la location
commission_amount = rental_price * 0.3
#on reprend le montant de la commission pour répartir la moitié du montant à l'assurance
insurance_fee = commission_amount * 0.5
#on récupère le montant restant de la commission pour le mettre dans une variable qu'on va utiliser
remaining_commission_amount = commission_amount - insurance_fee
#on va répartir 1€ par jour de location à l'assistance qui provient du montant restant de la commission
assistance_fee = rental_days * 100
#on récupère à nouveau le montant restant de la commission après toutes les pérécédentes déductions pour le mettre dans une variable qu'on va utiliser
remaining_commission_amount_2 = commission_amount - insurance_fee - assistance_fee
#on va répartir le reste de la commission à la société Drivy
drivy_fee = remaining_commission_amount_2
puts "ID #{rental['id']}, insurance_fee: #{insurance_fee.to_i}, assistance_fee: #{assistance_fee.to_i}, drivy_fee: #{drivy_fee.to_i}"
end
