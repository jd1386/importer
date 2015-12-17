require 'open-uri'
require 'json'
require 'csv'
require 'timeout'
require 'colorize'
require 'awesome_print'
require 'valid_email'


def query(email)
	begin
		JSON.parse(open("https://api.import.io/store/data/5d8a8c21-c2a4-4ee0-90af-1c0a9a9f2d24/_query?input/email=#{email}&_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D").read)
	rescue OpenURI::HTTPError => error
		response = error.io
		puts response.status.join(', ').red
	end
end

def parse(content)
	message = content["results"][0]

	if message != nil
		if message.has_key?("message_3")
			puts message["message_3"].blue
			@api_message = message["message_3"]
		else
			puts message["error_message"].red
			@api_message = message["error_message"]
		end
	else
		puts 'Unknown'.purple
		@api_message = "Unknown"
	end

end

def write_to_csv(email, message, last_checked_at)
  CSV.open("data/email_validator_results.csv", "a") do |csv|
		csv << [ email, message, last_checked_at ]
	end
end

def main_job(email, index)
	begin
		Timeout::timeout(30) do
			# Query to API
			@content = query(email)
			sleep 1

			if @content && @content["results"][0]
				# Parse returned results
				parse(@content)
				@container << [email, @api_message, Time.now, index]
			else
				# 503 error
				puts "503 Error:\t#{email}.".colorize(background: :red)
				@container << [email, 'Server unavailable', Time.now, index]
			end
		end
	rescue Timeout::Error
		# There's no content
		puts "Server timeout:\t#{email}.".colorize(background: :red)
		@container << [email, 'Server timeout', Time.now, index]
	end
end

@container = []
email_inputs = []
File.readlines('data/email_validator_source.txt').each do |line|
	email_inputs << line.strip
end
puts "Loaded #{email_inputs.size} emails."


dataset = []
q = 1

email_inputs.each_with_index do |email, index|
  puts "Validating #{email} ... #{index + 1} of #{email_inputs.size}"

	@threads = []
	@threads << Thread.new {
		main_job(email, index)
	 }

end

# Join threads
Thread.list.each do |t|
	t.join if t != Thread.current
end


# Sort threads by index value, otherwise it will mess up order
@container.sort_by! { |e| e[3] }

# Save results to csv
@container.each do |c|
	write_to_csv(c[0], c[1], c[2])
end

puts "*=*=*=*=*=*=*=", "The results saved to data/email_validator_results.csv."
