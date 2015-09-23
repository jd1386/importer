
#first_page = "http://www.bookdepository.com/category/2560/English-Literature/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(2..500).each do |page|
		f.puts "http://www.mayersche.de/buecher/kinderbuch-jugendbuch/#{page}/?sprache=ger&sortby=publicationdate&sortorder=desc"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"