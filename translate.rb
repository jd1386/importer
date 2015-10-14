require 'easy_translate'
require 'dotenv'
require 'titleize'
require 'retriable'
require 'csv'


Dotenv.load
EasyTranslate.api_key = ENV['GOOGLE_API_KEY']

texts_to_translate = []
# Load txt to translate
File.readlines('data/translate_source.txt').each do |line|
	texts_to_translate << line
end

processed_count = 0
text_to_translate_size = texts_to_translate.size


# Open up txt file to write to
CSV.open('data/translate_results.csv', 'w') do |csv| 
	
	# Loop through and query
	texts_to_translate.each do |text|
		@title_original = text.rstrip
		
		# Make query
		# In the case of (timeout) error, retry 3 times.
		Retriable.retriable do
			@language_detected = EasyTranslate::LANGUAGES[EasyTranslate.detect(@title_original)]
			@language_detected.nil? ? @language_detected = "Unknown" : @language_detected = @language_detected.capitalize
			
			#@title_translated = EasyTranslate.translate(@title_original, :from => ARGV[0], :to => 'en')
			#@title_translated = @title_translated.titleize
		end

		# Write to file
		csv << [ @language_detected ]

		# Write to screen
		processed_count += 1
		puts "#{processed_count} / #{text_to_translate_size} DONE from #{@language_detected}: #{@title_translated}"
		


	end

end


puts "All Done!"