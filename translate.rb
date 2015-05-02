require 'google_fish'
require 'dotenv'
require 'titleize'
require 'csv'

Dotenv.load
google = GoogleFish.new(ENV['GOOGLE_API_KEY'])

texts_to_translate = []
# Load txt to translate
File.readlines('data/translate_source.txt').each do |line|
	texts_to_translate << line
end

@processed_count = 0

# Loop through and query
texts_to_translate.each do |text|
	title_original = text.rstrip
	title_translated = google.translate(:es, :en, title_original).titleize

	puts title_translated
end


