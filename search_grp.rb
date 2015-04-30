require 'net/http'
require 'uri'
require 'json'


uri = URI("https://api.import.io/store/data/92a8cd90-fd0c-4eb8-99d3-1d1dc2c7fa42/_query?_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D")

req = Net::HTTP::Post.new(uri.to_s)
req.body = '{
    "input": {
        "isbn_prefix": "978-2-36266"
    },
    "additionalInput": {
        "92a8cd90-fd0c-4eb8-99d3-1d1dc2c7fa42": {
            "domainCredentials": {
                "grp.isbn-international.org": {
                    "username": "mewons",
                    "password": "pica0922"
                }
            }
        }
    }
}'
	req["content-type"] = "application/json"


dataset = []

Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
	response = http.request(req).body.force_encoding('UTF-8')
	parsed_response = JSON.parse(response)

	#puts parsed_response["results"]
	dataset << parsed_response["results"]
end

puts JSON.pretty_generate(dataset)