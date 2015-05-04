require 'google_fish'
require 'dotenv'
require 'titleize'
require 'retriable'
require 'csv'

Dotenv.load
google = GoogleFish.new(ENV['GOOGLE_API_KEY'])

texts_to_translate = []
# Load txt to translate
File.readlines('data/translate_source.txt').each do |line|
	texts_to_translate << line
end

processed_count = 0
text_to_translate_size = texts_to_translate.size

# Open up txt file to write to
File.open('data/translate_results.txt', 'w') do |f|
  
	# Loop through and query
	texts_to_translate.each do |text|
		title_original = text.rstrip
		
		# Make query
		# In the case of Timeout Error, retry 3 times.
		Retriable.retriable on: GoogleFish::Request::ApiError do
			@title_translated = google.translate(:sv, :en, title_original).titleize
		end

		# Write to file
		f.puts(@title_translated)

		# Write to screen
		processed_count += 1
		puts "DONE: #{@title_translated} #{processed_count} / #{text_to_translate_size}"
	end

end

puts "All Done!"