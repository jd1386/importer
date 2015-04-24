require 'open-uri'
require 'json'
require 'csv'
require 'timeout'

email_inputs = []
File.readlines('data/email_validator_source.txt').each do |line|
	email_inputs << line.strip
end
puts "Loaded #{email_inputs.size} emails."


dataset = []
q = 1

email_inputs.each do |email|
  puts "Validating #{email} ... #{q} of #{email_inputs.size}"
  q += 1

	begin
	  Timeout::timeout(30) do
	  	@content = JSON.parse(open("https://api.import.io/store/data/5d8a8c21-c2a4-4ee0-90af-1c0a9a9f2d24/_query?input/email=#{email}&_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D").read)
	  end
	rescue Timeout::Error
		# There's no @content

		puts "CONNECTION TIMED OUT:\t#{email}."
		break
	end  



  if @content["results"].empty? || @content["results"].nil?
  	puts "OK"
  	temp_hash = Hash.new
  	temp_hash[:message_3] = "E-mail address is valid"
  	
  	@content["results"] << temp_hash
  	dataset << @content["results"]
  else
    dataset << @content["results"]
  end

end

puts "All data received."
puts dataset.size

# Write to JSON
File.open('data/email_validator_results.json', 'w') do |f|
	f << JSON.pretty_generate(dataset)
end

puts "The results saved to data/email_validator_results.json."

json_file = JSON.parse(File.open("data/email_validator_results.json").read)
json_page_length = json_file.length


# Convert JSON to CSV
CSV.open("data/email_validator_results.csv", "w") do |csv|
# Write rows

	i = 0
	n = 0

	(i...json_page_length).each do 
		(n...json_file[i].length).each do
			csv << json_file[i][n].values_at( "message_3" )
			n += 1
		end
		n = 0
		i += 1
	end
end
puts "The results saved to data/email_validator_results.csv."