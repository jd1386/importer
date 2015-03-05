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
#client.query({"input"=>{"webpage/url"=>"http://www.bokus.com/cgi-bin/product_search.cgi?language=Svenska&subject=1&cat_static=1&rank_order=print_year_month_desc"},"connectorGuids"=>["e968bc43-7251-4da7-ba76-60b6a4b4416c"]}, callback )

# Page 2 and above
# Page n params == n - 1 

(101..300).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.bokus.com/cgi-bin/product_search.cgi?is_paginate=1&language=Svenska&subject=1&rank_order=print_year_month_desc&from=#{page}&cat_static=1"},"connectorGuids"=>["e968bc43-7251-4da7-ba76-60b6a4b4416c"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received!"

# Write the results to the file
File.new('data/se_recent_results.json', 'w') unless File.exists?('data/se_recent_results.json')
File.open('data/se_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/se_recent_results.json."

json_file = JSON.parse(File.open("data/se_recent_results.json").read)
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
CSV.open("data/se_recent_results.csv", "w") do |csv|
  # Write header
  csv << ["cover_image", "link_to_book", "link_to_book/_text"]
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("cover_image", "link_to_book", "link_to_book/_text")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/se_recent_results.csv"
