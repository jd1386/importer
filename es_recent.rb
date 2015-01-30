require "./importio.rb"
require "json" 
require "csv"

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect
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
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    q += 1
    puts "Query #{q} finished"
  end
end

# Query for tile CDL_ES
# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.casadellibro.com/busqueda-libros?nivel=2&novedad=-1&formato=-1&idcategoria=117001014&tipoAccion=-1&edad=-1&tipoproducto=-1&condicion=-1&idioma=-1&valoracion=-1&encuadernacion=-1&estadousuado=-1&idlibrero=-1&precio=-1&idcoleccion=-1&tipolector=-1&estadolectura=-1&ordenar=1"},"connectorGuids"=>["7a0e4368-0e09-4c62-9584-67e8f48435bc"]}, callback )

# Page 2 and above
(2..23).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.casadellibro.com/busqueda-libros?spellcheck=1&page=#{page}&idcategoria=117001014&ordenar=1&idtipoproducto=1&nivel=2"},"connectorGuids"=>["7a0e4368-0e09-4c62-9584-67e8f48435bc"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received! Writing the results to the file."

# Write the results to a file
File.new('data/es_recent_results.json', 'w') unless File.exists?('data/es_recent_results.json')
File.open('data/es_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/es_recent_results.json."

json_file = JSON.parse(File.open("data/es_recent_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# Check if every book from every page has been scraped
puts "\n:::Results:::"
puts "Page\tBooks Scraped"
puts "----------------------"

i = 0
(i...json_page_length).each do 
  #(n...json_book_per_page_length).each do |hash|
    puts "page #{i + 1}\t#{json_file[i].length}"
    if json_file[i].length == 0
      puts "Sorry, page #{i + 1} was not scraped. Please retry."
      abort
    end
  #end
  i += 1
end


# If all the books are successfully scraped, convert JSON to CSV
CSV.open("data/es_recent_results.csv", "w") do |csv|
  # Write header
  csv << json_file[0][0].keys
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/es_recent_results.csv"

# All done!
puts "와우! 이번 미션은 성공적이었네. 축하하네."