require 'net/http'
require 'uri'
require 'json'
require 'csv'
require 'awesome_print'
require 'dotenv'
require 'retriable'

Dotenv.load


isbn_prefixes = []

# Load isbn prefixes
File.readlines('data/search_grp_source.txt').each do |line|
  isbn_prefixes << line.rstrip
end

@processed_count = 0

uri = URI.parse("https://api.import.io/store/data/7a870b90-71d4-4ff6-9d55-bc927c6e6979/_query?_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D")

# Loop through prefixes to look up
isbn_prefixes.each do |prefix|

    @req = Net::HTTP::Post.new(uri)
    @req.body = {
        "input" => {
            "isbn_prefix" => prefix.rstrip
        },
        "additionalInput" => {
            "7a870b90-71d4-4ff6-9d55-bc927c6e6979" => {
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


    # Connect and receive and parse response. 
    # In the case of Timeout Error, retry 3 times.
    Retriable.retriable on: Timeout::Error do
        
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    	response = http.request(@req).body.force_encoding('UTF-8')
    	@parsed_response = JSON.parse(response)   

    end
end


# Save @parsed_response to CSV
CSV.open("data/search_grp_results.csv", "a") do |row|
    # debug 
    ap @parsed_response["results"]
    # end debug

    if @parsed_response["results"].nil?
        row << [
                JSON.parse(@req.body)["input"]["isbn_prefix"],
                "Error. Please try again"
        ]
        next


     # If no results found with the given isbn prefix
    elsif @parsed_response["results"].empty?
        row << [
                JSON.parse(@req.body)["input"]["isbn_prefix"],
                "No results found"
                ]
    
    # Success        
    else
        # Multiple companies found with given isbn prefix
        if @parsed_response["results"][0]["company"].is_a? Array
            (0...@parsed_response["results"][0]["company"].size).each do |n|
                row << [ 
                    JSON.parse(@req.body)["input"]["isbn_prefix"],
                    @parsed_response["results"][0]["company"][n],
                    @parsed_response["results"][0]["meta_all"][n]
                ]
            end
        
        else
            row << [ 
                JSON.parse(@req.body)["input"]["isbn_prefix"],
                @parsed_response["results"][0]["company"],
                @parsed_response["results"][0]["meta_all"]
                ]
        end
    end

end # end CSV

@processed_count += 1
puts JSON.parse(@req.body)["input"]["isbn_prefix"] + " done! Processed #{@processed_count} / #{isbn_prefixes.size} prefixes"

end # end isbn_prefixes.each loop

puts "Success! All done."