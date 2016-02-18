
# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(1001..1450).each do |page|
		f.puts "https://www.kinokuniya.co.jp/f/dsd-001001020-01-?p=#{page}"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"