require 'net/http'
require 'uri'
require 'json'
require 'csv'
require 'awesome_print'
require 'retriable'

urls = []
File.readlines('data/fr_amazon_meta_source.txt').each do |line|
	urls << line.rstrip
end

CSV.open("data/fr_amazon_meta_results.csv", "w", encoding: 'UTF-8') do |csv|
  # Write the results header to csv
  csv << ["pageUrl", "isbn", "title", "categories/_text", "age_group"]
end


uri = URI.parse("https://api.import.io/store/data/ef9c29c5-b862-4599-80f6-2d551e1391eb/_query?_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D")


@query_count = 0
@urls_count = urls.size

urls.each do |url|
	@req = Net::HTTP::Post.new(uri)
	@req.body = {
	        "input" => {
	            "webpage/url" => url
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

	# Connect and receive and parse response. 
  # In the case of Timeout Error, retry 3 times.
  Retriable.retriable on: Timeout::Error do
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
	  	response = http.request(@req).body.force_encoding('UTF-8')
	  	@parsed_response = JSON.parse(response)
	  end
  end


 	# Save @parsed_response to CSV
CSV.open("data/fr_amazon_meta_results.csv", "a", encoding: 'UTF-8') do |csv|
  if @parsed_response["results"].nil?
  	csv << [
            @parsed_response["pageUrl"],
            "Nil"
    ]

   # If no results found with the given isbn prefix
  elsif @parsed_response["results"].empty?
      csv << [
              @parsed_response["pageUrl"],
              "Empty"
      ]

  else
    # Write the results body to csv
    @pageUrl = @parsed_response["pageUrl"]

    if @parsed_response["results"][0]["isbn"].nil?
    	@isbn = ""
    else
    	@isbn = @parsed_response["results"][0]["isbn"].gsub('-', '').to_i
    end

    @title = @parsed_response["results"][0]["title"]

    if @parsed_response["results"][0]["categories/_text"].nil?
      @categories = ""
    else
      @categories = @parsed_response["results"][0]["categories/_text"].join(", ")
    end     

    if @parsed_response["results"][0]["age_group"].is_a? Array
      @age_group = @parsed_response["results"][0]["age_group"][0]
    else
      @age_group = @parsed_response["results"][0]["age_group"]
    end


    csv << [@pageUrl, @isbn, @title, @categories, @age_group]
  end

end # end CSV

@query_count += 1

ap "#{@query_count} / #{@urls_count} DONE: #{@title}"
end # end urls loop