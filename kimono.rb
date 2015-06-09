require 'csv'
require 'json'
require 'rest_client'
require 'awesome_print'

@api = '7sq28t0u'
@apikey = 'qNE3m3lrmLG6BAKxiUdqEa0T5I3uUe7c'

def job_completed?
	response_json = RestClient.get "https://www.kimonolabs.com/api/#{@api}",
		apikey: @apikey
	response_json = JSON.parse(response_json)

	
	if response_json["lastrunstatus"].eql? "success"
		true 
	elsif response_json["lastrunstatus"].eql? "in progress"
		false
	end
	
end

# Clear 'kimono_results.csv'
File.delete('data/kimono_results.csv') if File.exists?('data/kimono_results.csv')


# Load target urls
urls = []
File.readlines('data/kimono_urls.txt').each do |line|
	urls << line.rstrip
end
puts "Loaded #{urls.size} urls."


puts job_completed?
abort 'Job not completed yet. try later' if job_completed? == false


# Settings
RestClient.post "https://www.kimonolabs.com/kimonoapis/#{@api}/update",
	apikey: @apikey,
	urls: urls

# Run crawler
RestClient.post "https://www.kimonolabs.com/kimonoapis/#{@api}/startcrawl",
	apikey: @apikey

# Get results
response_json = RestClient.get "https://www.kimonolabs.com/api/#{@api}",
	apikey: @apikey,
	kimbypage: 1

response_json = JSON.parse(response_json)




# Collection1
response_json["results"]["collection1"].each do |row|
	isbn = row["isbn"]
	title = row["title"]
	index = row["index"]
	url = row["url"]

	categories = []
	response_json["results"]["collection2"].each do |row2|
		
		if url.eql? row2["url"]
			categories << row2["categories"]["text"]
		end
		
	end
	ap categories = categories.join(' ; ')
	
	CSV.open("data/kimono_results.csv", "a", encoding: "UTF-8") do |csv|
		csv << [isbn, title, index, url, categories]
	end

end

# response_json["results"]["collection2"].each do |row|
# 	categories_text = row["categories"]["text"]
# 	index = row["index"]
# 	url = row["url"]

# 	CSV.open("data/kimono_results.csv", "a") do |csv|
# 		csv << ['', categories_text, index, url]
# 	end

# end


#response_csv = RestClient.get "https://www.kimonolabs.com/api/csv/#{@api}"
#ap response_csv

