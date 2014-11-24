require 'rest_client'

response = RestClient.get 'https://www.kimonolabs.com/api/csv/2z28p7d8?apikey=qNE3m3lrmLG6BAKxiUdqEa0T5I3uUe7c'

puts response

# Create a new json file unless it already exists
File.new('data/it_kimono_ex_results.csv', 'w') unless File.exists?('data/it_kimono_ex_results.csv')
# Open the file and write the data results to results_file.json
File.open('data/it_kimono_ex_results.csv', 'w') do |f|
  f << response
end

puts "Done. saved to the results file."