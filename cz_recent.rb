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
    elsif message["data"]["results"].empty?
      abort "Error!"
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
#client.query({"input"=>{"webpage/url"=>"http://neoluxor.cz/detske/?f:ord=4&f:dir=0&f:lt=1"},"connectorGuids"=>["7c6137f0-e3da-4338-910a-71d710f669cf"]}, callback )

# Page 2 and above
# Page n params == n - 1 

(151..200).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://neoluxor.cz/detske/?f:ord=4&f:dir=0&f:lt=1&b.pagenumber=#{page}&preserveFilter=1"},"connectorGuids"=>["7c6137f0-e3da-4338-910a-71d710f669cf"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received!"

# Write the results to the file
File.new('data/cz_recent_results.json', 'w') unless File.exists?('data/cz_recent_results.json')
File.open('data/cz_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/cz_recent_results.json."

json_file = JSON.parse(File.open("data/cz_recent_results.json").read)
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
CSV.open("data/cz_recent_results.csv", "w") do |csv|
  # Write header
  csv << ["link_to_book", "link_to_book/_text", "author"]
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("link_to_book", "link_to_book/_text", "author")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/cz_recent_results.csv"
