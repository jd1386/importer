require "./importio.rb"
require "json"
require 'csv' 

# To use an API key for authentication, use the following code:
client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

@query_total = CSV.readlines('data/books.com.tw.csv').size
@query_num = 0

# Once we have started the client and authenticated, we need to connect it to the server:
client.connect

# Define here a global variable that we can put all our results in to when they come back from
# the server, so we can use the data later on in the script
data_rows = []

# In order to receive the data from the queries we issue, we need to define a callback method
# This method will receive each message that comes back from the queries, and we can take that
# data and store it for use in our app
callback = lambda do |query, message|
  # Disconnect messages happen if we disconnect the client library while a query is in progress
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
    @query_num += 1

    puts "Query #{@query_num} / #{@query_total} finished"
  end
end


# Read CSV file that contains urls to scrape
options = { encoding: 'UTF-8', skip_blanks: true, headers: true}

CSV.foreach('data/books.com.tw.csv', options) do |row|
  client.query({"input"=>{"webpage/url"=>row},"connectorGuids"=>["607b0e2e-c8a2-47c9-966f-0107ede09f25"]}, callback )
end


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

# Create a new json file to apply data_rows
File.new('data/taiwan_results.json', 'a') unless File.exists?('data/taiwan_results.json')

# Open the file and append the data results to results_file
# data_rows is now in hash. Need to change it to array compatible 

File.open('data/taiwan_results.json', 'a') do |f|
  f << JSON.pretty_generate(data_rows)
end

# Now we have the results file in json format.
puts "The data is appended to the data/taiwan_results.json file."
