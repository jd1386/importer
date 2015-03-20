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
    puts "Query finished"
  end
end

# Query for tile it_extract_feltrinelli
(151..250).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/libri-ragazzi/c-1045/0/#{page}/"},"connectorGuids"=>["508a560d-aa6c-4a39-925a-3d9b65ec26f1"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Extract isbn from data_rows
isbns = []
i = 0
n = 0

until i == data_rows.size
  until n == data_rows[i].size
    puts data_rows[i][n]['book_page_url']
    isbns << data_rows[i][n]['book_page_url'].match(/978(?:-?\d){10}/)
    n += 1
  end
  i += 1
  n = 0
end

puts isbns
puts "ISBNS size: #{isbns.size}"
sleep 1

# Create a new json file unless it already exists
File.new('data/it_recent_results.txt', 'w') unless File.exists?('data/it_recent_results.txt')
# Open the file and write the data results to results_file.json
File.open('data/it_recent_results.txt', 'w') do |f|
  isbns.each { |isbn| f.puts(isbn) }
end

puts "All done! See data/it_recent_results.txt"