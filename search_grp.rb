require 'net/http'
require 'uri'
require 'json'
require 'csv'
require 'awesome_print'
require 'dotenv'

Dotenv.load


uri = URI.parse("https://api.import.io/store/data/92a8cd90-fd0c-4eb8-99d3-1d1dc2c7fa42/_query?_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D ")

isbn_prefixes = []

# Load isbn prefixes
File.readlines('data/search_grp_source.txt').each do |line|
  isbn_prefixes << line.rstrip
end

@processed_count = 0

# Loop through prefixes to look up
isbn_prefixes.each do |prefix|

    @req = Net::HTTP::Post.new(uri)
    @req.body = {
        "input" => {
            "isbn_prefix" => prefix
        },
        "additionalInput" => {
            "92a8cd90-fd0c-4eb8-99d3-1d1dc2c7fa42" => {
                "domainCredentials" => {
                    "grp.isbn-international.org" => {
                        "username" => ENV['GRP_USER_ID'],
                        "password" => ENV['GRP_USER_PASSWORD']
                    }
                }
            }
        }
    }.to_json
    @req["content-type"] = "application/json"



    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    	response = http.request(@req).body.force_encoding('UTF-8')
    	@parsed_response = JSON.parse(response)   

    end


# Save @parsed_response to CSV
CSV.open("data/search_grp_results.csv", "a") do |csv|
    
     # If no results found with the given isbn prefix
    if @parsed_response["results"].empty?
        csv << [
                JSON.parse(@req.body)["input"]["isbn_prefix"],
                "No results found"
        ]
    else
        # If multiple search records with the given isbn prefix,
        # display it on each row
        if @parsed_response["totalResults"] >= 2
            i = 0        
            (0...@parsed_response["results"][0]["company_name"].size).each do
                
                csv << [ 
                        JSON.parse(@req.body)["input"]["isbn_prefix"], 
                        @parsed_response["results"][0]["country"][i], 
                        @parsed_response["results"][0]["agency_name"][i],
                        @parsed_response["results"][0]["company_name"][i],
                        @parsed_response["results"][0]["isbn_prefix"][i],
                        @parsed_response["results"][0]["meta_all"][i]
                        ]
                i += 1
            end
        else 
            csv << [ 
                    JSON.parse(@req.body)["input"]["isbn_prefix"], 
                    @parsed_response["results"][0]["country"], 
                    @parsed_response["results"][0]["agency_name"],
                    @parsed_response["results"][0]["company_name"],
                    @parsed_response["results"][0]["isbn_prefix"],
                    @parsed_response["results"][0]["meta_all"]
                    ]
        end
    end

end # end CSV

@processed_count += 1
puts JSON.parse(@req.body)["input"]["isbn_prefix"] + " done! Processed #{@processed_count} / #{isbn_prefixes.size} prefixes"

end # end isbn_prefixes.each loop

puts "Success! All done."