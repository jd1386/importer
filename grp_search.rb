require "./importio.rb"
require "json" 
require "csv"


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []
q = 1

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query #{q} finished"
    q += 1
  end
end


File.readlines('data/grp_search_source.txt').each do |source|
  source_cleaned = source.gsub /\t/, '-'
  puts source_cleaned
  client.query({"input"=>{"search_term"=>source_cleaned},"connectorGuids"=>["78238619-1b83-4ecd-bd67-47dc854ac65c"]}, callback )
end

#puts "Queries dispatched, now waiting for results"
#client.join
#puts "Join completed, all results returned"
#client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)



# Write the results to the file
File.new('data/grp_search_results.json', 'w') unless File.exists?('data/grp_search_results.json')
File.open('data/grp_search_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/grp_search_results.json."

json_file = JSON.parse(File.open("data/grp_search_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# Convert JSON to CSV
CSV.open("data/grp_search_results.csv", "w") do |csv|
  # Write header
  csv << [ "country", "publisher", "isbn_prefix" ]

  # Write rows

  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at( "country", "publisher", "isbn_prefix" )
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/grp_search_results.csv"