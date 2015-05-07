require 'titleize'

titles_to_fix = []
# Load dates to fix
File.readlines('data/titleize_source.txt').each do |line|
	titles_to_fix << line.rstrip
end


# Write the results to file
File.open('data/titleize_results.txt', 'w') do |f|
	titles_to_fix.each do |title|
		f.puts title.titleize
		puts title.titleize
	end
end

