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

# Page 1
#client.query({"input"=>{"webpage/url"=>"http://www.mondadoristore.it/libri/ragazzi/Bambini-e-Ragazzi/genG004/?tpr=250&crc=164&gen=G004&sort=7&opnedBoxes=amtp%2Catpp%2Casgn%2Capzf%2Cascf%2Caaut%2Caedt%2Cacol%2Camtp%2Catpp%2Casgn"},"connectorGuids"=>["8982aca8-d1ad-48ca-95c8-32d77e9fbb8d"]}, callback )

# Query for tile it_extract_feltrinelli
(631..650).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.mondadoristore.it/libri/ragazzi/Bambini-e-Ragazzi/genG004/#{page}/crc=164&gen=G004&opnedBoxes=amtp%2Catpp%2Casgn%2Capzf%2Cascf%2Caaut%2Caedt%2Cacol%2Camtp%2Catpp%2Casgn&sort=7&tpr=250"},"connectorGuids"=>["8982aca8-d1ad-48ca-95c8-32d77e9fbb8d"]}, callback )
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
    isbns << data_rows[i][n]['link_to_book'].match(/978(?:-?\d){9}/)
    n += 1
  end
  i += 1
  n = 0
end

puts isbns
puts "ISBNS size: #{isbns.size}"
sleep 1

# Create a new json file unless it already exists
File.new('data/it_recent_isbn_results.txt', 'w') unless File.exists?('data/it_recent_isbn_results.txt')
# Open the file and write the data results to results_file.json
File.open('data/it_recent_isbn_results.txt', 'w') do |f|
  isbns.each { |isbn| f.puts(isbn) }
end

puts "All done! See data/it_recent_isbn_results.txt"

# Write the results to the file
File.new('data/it_recent_results.json', 'w') unless File.exists?('data/it_recent_results.json')
File.open('data/it_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/it_recent_results.json."

json_file = JSON.parse(File.open("data/it_recent_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# Check if every book from every page has been scraped
puts "\n:::Results:::"
puts "Page\tBooks Scraped"
puts "----------------------"

i = 0
(i...json_page_length).each do 
  puts "page #{i + 1}\t#{json_file[i].length}"
  if json_file[i].length == 0
    puts "Oops, page #{i + 1} was not scraped. Please retry."
    abort
  end
i += 1
end

# If all the books are successfully scraped, convert JSON to CSV
CSV.open("data/it_recent_results.csv", "w") do |csv|
  # Write header
  csv << ["link_to_book", "link_to_book/_title"]
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("link_to_book", "link_to_book/_title")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/it_recent_results.csv"