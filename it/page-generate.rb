
#first_page = "http://www.bookdepository.com/category/2560/English-Literature/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(2..150).each do |page|
		f.puts "http://www.mondadoristore.it/libri/ragazzi/Bambini-e-Ragazzi/genG004/#{page}/crc=164&gen=G004&opnedBoxes=amtp%2Catpp%2Casgn%2Capzf%2Cascf%2Caaut%2Caedt%2Cacol%2Camtp%2Catpp%2Casgn&sort=7&tpr=250"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"
