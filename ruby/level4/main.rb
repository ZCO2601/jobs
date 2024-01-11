require 'json'
require 'date'

# Règle de calcul pour trouver le prix total de la location après des réductions dégressives en fonction du nombre de jours de location
def calculate_price_per_day(price, days)
  return price if days == 1
  return (price * 0.9) + ((days - 1) * price) if days > 1
  return (price * 0.9) + (3 * price * 0.7) + (days * price * 0.5) if days > 10
end

# Fonction pour déterminer le type d'action en fonction de l'acteur
def determine_action(actor, amount)
  case actor
  when 'driver'
    return 'debit'
  when 'owner', 'insurance', 'assistance', 'drivy'
    return 'credit'
  else
    return 'unknown'
  end
end

file_path = File.join(File.dirname(__FILE__), 'data', 'input.json')
file = File.read(file_path)
data = JSON.parse(file)
# on définit une variable qui contient un hash avec la clé "rentals" qui contient un tableau vide pour contenir les résultats pour chaque location
result = { "rentals" => [] }

data['rentals'].each do |rental|
  car = data['cars'].find { |c| c['id'] == rental['car_id'] }
  rental_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
  distance_price = rental['distance'] * car['price_per_km']
  time_price = calculate_price_per_day(car['price_per_day'], rental_days)
  rental_price = distance_price + time_price

  # Règles de calcul pour tous les types de frais
  commission_amount = rental_price * 0.3
  insurance_fee = commission_amount * 0.5
  assistance_fee = rental_days * 100
  remaining_commission_amount_2 = commission_amount - insurance_fee - assistance_fee
  drivy_fee = remaining_commission_amount_2
  owner_credit = rental_price - commission_amount
  driver_debit = rental_price

  # Array contenant les actions et montants correspondants en fonction du type d'acteur
  actions = [
    { "who": "driver", "type": determine_action('driver', driver_debit), "amount": driver_debit.to_i },
    { "who": "owner", "type": determine_action('owner', owner_credit), "amount": owner_credit.to_i },
    { "who": "insurance", "type": determine_action('insurance', insurance_fee), "amount": insurance_fee.to_i },
    { "who": "assistance", "type": determine_action('assistance', assistance_fee), "amount": assistance_fee.to_i },
    { "who": "drivy", "type": determine_action('drivy', drivy_fee), "amount": drivy_fee.to_i }
  ]
  # Ajout du résultat dans le tableau result
  result["rentals"] << { "id" => rental['id'], "actions" => actions }
  #On itère sur le tableau actions pour afficher le résultat de chaque location avec l'acteur de l'action, le type d'action et le montant associé
  actions.each do |action|
    puts "#{action['who']} #{action['type']} #{action['amount']}"
  end
end
  #on affiche le résultat final sous forme de JSON
  puts JSON.pretty_generate(result)
