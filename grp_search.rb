require "./importio.rb"
require "json" 

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect
data_rows = []

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      # In this case, we received a message, but it was an error from the external service
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
  	else
      # We got a message and it was not an error, so we can process the data
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      # Save the data we got in our dataRows variable for later
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query finished"
  end
end

# Query for tile grp_search_extract
client.query({"input"=>{"keys"=>"97888"}, "additionalInput"=>{"2b7bcd4e-3af5-4154-8153-83bb8741a83e"=>{"cookies"=>["SESS75a43650f19a0a9283d3e69ac0373322=\"OLBT233wL7E8XYpmaEBxuhaQO2QrzW5dVWXpAG1wfKY\";Path=\"/\";Domain=\"grp.isbn-international.org\";Port=\"443\"",
                "has_js=\"1\";Path=\"/\";Domain=\"grp.isbn-international.org\";Port=\"443\""]}},"connectorGuids"=>["2b7bcd4e-3af5-4154-8153-83bb8741a83e"]}, callback )

client.query({"input"=>{"keys"=>"97887"}, "additionalInput"=>{"2b7bcd4e-3af5-4154-8153-83bb8741a83e"=>{"cookies"=>["SESS75a43650f19a0a9283d3e69ac0373322=\"OLBT233wL7E8XYpmaEBxuhaQO2QrzW5dVWXpAG1wfKY\";Path=\"/\";Domain=\"grp.isbn-international.org\";Port=\"443\"",
                "has_js=\"1\";Path=\"/\";Domain=\"grp.isbn-international.org\";Port=\"443\""]}},"connectorGuids"=>["2b7bcd4e-3af5-4154-8153-83bb8741a83e"]}, callback )


puts "Queries dispatched, now waiting for results"

# Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
client.join

puts "Join completed, all results returned"

# It is best practice to disconnect when you are finished sending queries and getting data - it allows us to
# clean up resources on the client and the server
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Create a new json file unless it already exists
File.new('data/grp_search_results.json', 'w') unless File.exists?('data/grp_search_results.json')
# Open the file and write the data results to results_file.json
File.open('data/grp_search_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "All done! See data/grp_search_results.json"