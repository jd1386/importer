require 'rest_client'

response = RestClient.get 'https://www.kimonolabs.com/api/2z28p7d8?apikey=qNE3m3lrmLG6BAKxiUdqEa0T5I3uUe7c'

puts response