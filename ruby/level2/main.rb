require "json"
require "date"

#on définit une méthode qui calcule le prix par jour en fonction du nombre de jours
def calculate_price_per_day(price, days)
  return price if days == 1
  #si le nombre de jours est égal à 1, le prix ne change pas
  return (price * 0.9) + ((days - 1) * price) if days > 1
  #on multiplie le prix par 0.9 pour le deuxième jour pour appliquer la réduction de 10%
  #on ajoute le nombre de jours auquel on soustrait 1 car le premier jour est déjà compté dans le prix
  #on multiplie le tout par le prix qui est le résultat de (price * 0.9)
  #le tout si le nombre de jours est supérieur à 1
  return (price * 0.9) + (3 * price * 0.7) if days > 4
  #on multiplie le prix par 0.9 pour le deuxième jour pour appliquer la réduction de 10%
  #on ajoute le prix multiplié par 0.9 et multiplié par 3 pour les 3 jours suivants car la réduction est de 10% pour les jour 2 à 4
  #on soustrait 4 au nombre de jours pour ne pas compter les 4 premiers jours
  #on multiplie par le prix qui a été multiplié par 0.7 pour appliquer la réduction de 30% après le 4ème jour
  #le tout si le nombre de jours est supérieur à 4
  return (price * 0.9) + (3 * price * 0.7) + (6 * price * 0.5) if days > 10

  #return (price * 0.9) + (3 * price * 0.9) + (6 * price * 0.7) + ((days - 10) * price * 0.5) if days > 10
  #on multiplie le prix par 0.9 pour le deuxième jour pour appliquer la réduction de 10%
  #on ajoute le prix multiplié par 0.9 et multiplié par 3 pour les 3 jours suivants car la réduction est de 10% pour les jour 2 à 4
  #on ajoute le prix multiplié par 0.7 et multiplié par 6 pour les 6 jours suivants car la réduction est de 30% pour les jour 5 à 10
  #on soustrait 10 au nombre de jours pour ne pas compter les 10 premiers jours
  #on multiplie le tout par le prix qui a été multiplié par 0.5 pour appliquer la réduction de 50% après le 10ème jour
  #le tout si le nombre de jours est supérieur à 10
end

file_path = File.join(File.dirname(__FILE__), "Data", "input.json")
file = File.read(file_path)
data = JSON.parse(file)

data["rentals"].each do |rental|
  car = data["cars"].find { |c| c["id"] == rental["car_id"] }
  distance_price = car["price_per_km"] * rental["distance"]
  rental_days = (Date.parse(rental["end_date"]) - Date.parse(rental["start_date"])).to_i + 1
  time_price = calculate_price_per_day(car["price_per_day"], rental_days)

  rental_price = distance_price + time_price
  puts "ID: #{rental["id"]}, Price: #{rental_price.to_i}" # to_i pour convertir le prix en entier
end
