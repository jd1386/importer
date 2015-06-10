require 'csv'
require 'json'
require 'rest_client'
require 'awesome_print'

@api = '7sq28t0u'
@apikey = 'qNE3m3lrmLG6BAKxiUdqEa0T5I3uUe7c'

# Load target urls
def load_urls
	@urls = []
	File.readlines('data/kimono_urls.txt').each do |line|
		@urls << line.rstrip
	end
	puts "Loaded #{@urls.size} urls."	
end


def job_completed?
	@response_json = RestClient.get "https://www.kimonolabs.com/api/#{@api}",
		apikey: @apikey
	@response_json = JSON.parse(@response_json)

	
	if @response_json["lastrunstatus"] != 'in progress'
		true 
	else
		false
	end
	
end

def start_new_job
# Load urls
load_urls

#Settings
	RestClient.post "https://www.kimonolabs.com/kimonoapis/#{@api}/update",
	apikey: @apikey,
	urls: @urls
	puts "Setting for crawler updated!"

# Run crawler
	RestClient.post "https://www.kimonolabs.com/kimonoapis/#{@api}/startcrawl",
	apikey: @apikey
	puts "Crawler started!"

end

def parse_results
	# Collection1
	@response_json["results"]["collection1"].each do |row|
		if row["isbn"] && row["isbn"].include?('-')
			isbn = row["isbn"].gsub("-", "")
		end

		title = row["title"]
		index = row["index"]
		url = row["url"]

		categories = []
		@response_json["results"]["collection2"].each do |row2|
			
			if url.eql? row2["url"]
				categories << row2["categories"]["text"]
			end
			
		end
		ap categories = categories.join(' ; ')
		
		CSV.open("data/kimono_results.csv", "a", encoding: "UTF-8") do |csv|
			csv << [isbn, title, index, url, categories]
		end
	end
end

# Clear 'kimono_results.csv'
File.delete('data/kimono_results.csv') if File.exists?('data/kimono_results.csv')



# puts job_completed?
# abort 'Job not completed yet. try later' if job_completed? == false

if ARGV[0] == 'new'
puts "Starting a new crawler..."
start_new_job
abort 'OK'
elsif ARGV[0] == 'status'
	if job_completed? == true
		parse_results
		puts "Job done!"
	else
		abort 'Job in progress...'
	end
end

