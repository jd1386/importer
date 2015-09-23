
#first_page = "http://www.bookdepository.com/category/2560/English-Literature/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(2..80).each do |page|
		f.puts "http://merlin.pl/dla-dzieci/browse/search/1,393,#{page}.html?sort=nowosc&offer=O&&prices=20,50,100,200,300,500,1000&carrier=18&price=%5B0%20TO%20*%5D&firm=&keywords="
	end
end
puts "Done! The results saved to data/page-generate-results.txt"