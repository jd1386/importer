require "./importio.rb"
require "json" 
require "csv"

#########################
#### NOTE ####
# poche et broche (=> desired_format no. 1)
# http://www.amazon.fr/gp/search/ref=sr_il_ti_stripbooks?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A2012%2Cp_n_binding_browse-bin%3A492481011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3AGallimard+Jeunesse&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks

# relie (=> desired_format no. 2)
# http://www.amazon.fr/gp/search/ref=sr_il_ti_stripbooks?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A2012%2Cp_n_binding_browse-bin%3A492480011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3AGallimard+Jeunesse&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks

#########################

#########################
#### GLOBAL SETTINGS ####

company = 'Gallimard Jeunesse'
year = 2012
last_page = 1
desired_format = 2

#########################


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
  	else
      if message["data"]["results"].length == 0
      	puts "Got data!"
        puts JSON.pretty_generate(message["data"])
        puts "Oops! Error occurred! Try again."
        abort
      else
        puts "Got data!"
        puts JSON.pretty_generate(message["data"])
        data_rows << message["data"]["results"]
      end
    end
  end
  if query.finished
    puts "Query finished"
  end
end

# Query for FR_URL
# User want to scrape only poche et broche
if desired_format == 1
	# poche et broche: Page 1 
	client.query({"input"=>{"webpage/url"=>"http://www.amazon.fr/gp/search/ref=sr_il_ti_stripbooks?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A#{year}%2Cp_n_binding_browse-bin%3A492481011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3A#{company.gsub(" ", "+")}&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks"},"connectorGuids"=>["50e19202-15b8-4fc5-a2ac-4f3464e29a39"]}, callback )

	# poche et broche: Page 2 and above
	(2..last_page).each do |page|
		client.query({"input"=>{"webpage/url"=>"http://www.amazon.fr/s/ref=sr_pg_#{page}?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A#{year}%2Cp_n_binding_browse-bin%3A492481011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3A#{company.gsub(" ", "+")}&page=#{page}&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks"},"connectorGuids"=>["50e19202-15b8-4fc5-a2ac-4f3464e29a39"]}, callback )
	end

# User want to scrape only relie
else
# relie: Page 1 
	client.query({"input"=>{"webpage/url"=>"http://www.amazon.fr/gp/search/ref=sr_il_ti_stripbooks?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A#{year}%2Cp_n_binding_browse-bin%3A492480011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3A#{company.gsub(" ", "+")}&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks"},"connectorGuids"=>["50e19202-15b8-4fc5-a2ac-4f3464e29a39"]}, callback )

	# relie: Page 2 and above
	#(2..last_page).each do |page|
	#	client.query({"input"=>{"webpage/url"=>"http://www.amazon.fr/s/ref=sr_pg_#{page}?rh=n%3A301061%2Cn%3A%21301130%2Cn%3A301137%2Cp_47%3A2012%2Cp_n_binding_browse-bin%3A492480011%2Cp_45%3A1%2Cp_46%3AAfter%2Cp_30%3A#{company.gsub(" ", "+")}&page=#{page}&sort=date-desc-rank&unfiltered=1&ie=UTF8&lo=stripbooks"},"connectorGuids"=>["50e19202-15b8-4fc5-a2ac-4f3464e29a39"]}, callback )
	# end
end

puts "Queries dispatched, now waiting for results"

client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received! Writing the results to the file."

# Write the results to the json file
File.new('data/fr_url_results_' + desired_format.to_s + '.json', 'w') unless File.exists?('data/fr_url_results_' + desired_format.to_s + '.json')
File.open('data/fr_url_results_' + desired_format.to_s + '.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/fr_url_results_#{desired_format}.json."

json_file = JSON.parse(File.open('data/fr_url_results_' + desired_format.to_s + '.json').read)
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
    puts "Sorry, page #{i + 1} was not scraped. Please retry."
    abort
  end
i += 1
end


# If all the books are successfully scraped, convert JSON to CSV
CSV.open('data/fr_url_results_' + desired_format.to_s + '.csv', "w") do |csv|
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
puts "The results saved to data/fr_url_results_#{desired_format}.csv"

# All done!
puts "와우! 이번 미션은 성공적이었네. 축하하네."