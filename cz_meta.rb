require "./importio.rb"
require "json" 
require "csv"

# Read and save book page urls
book_page_urls = []
File.readlines('data/cz_meta_source.txt').each do |line|
  book_page_urls << line
end
book_page_urls_size = book_page_urls.size

puts "Loaded: #{book_page_urls_size} destinations.
    \nDeploying the pigeon..."
puts "Connecting to client..."


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect
puts "Connected to client!"

data_rows = []
q = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
  	else
      if message["data"]["results"].length == 0
        puts "Oops. No data found!"
        data_rows << [{"title" => "N/A"}]
      else
        puts "Got data!"
        puts JSON.pretty_generate(message["data"])
        data_rows << message["data"]["results"]
      end
    end
  end
  if query.finished
    q += 1
    puts "The pigeon picked #{q} / #{book_page_urls_size} berries. #{book_page_urls_size - q} remaining."
    if book_page_urls_size - q == 100
      system('say "100 remaining" ')
    elsif book_page_urls_size - q == 10
      system('say "10 remaining" ')
    end
  end
end

# Query for tile DE_META
book_page_urls.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["a7616131-d62a-4fda-9133-db945603e1fe"]}, callback )
end

if book_page_urls_size < 100
  puts "Queries dispatched, now waiting for results"
  client.join
  puts "Join completed, all results returned"
  client.disconnect
end

# Now we can print out the data we got
puts "All data received! Writing the results to the file."

# Write the results to the file
File.new('data/cz_meta_results.json', 'w') unless File.exists?('data/cz_meta_results.json')
File.open('data/cz_meta_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end
puts "Done! The results saved to data/cz_meta_results.json."

# Check if every book from every page has been scraped
json_file = JSON.parse(File.open("data/cz_meta_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# If all the books are successfully scraped, convert JSON to CSV
CSV.open("data/cz_meta_results.csv", "w") do |csv|
  # Write header
  csv << ["title", "authors", "category", "book_description", "meta_all"]
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("title", "authors", "category", "book_description", "meta_all")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/cz_meta_results.csv"


# All done!
puts "와우! 비둘기가 성공적으로 돌아왔다!"
2.times.each do
  system('say "The pigeon has come back master" ')
  sleep 1
end
