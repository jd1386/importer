
#first_page = "http://www.bookdepository.com/category/2560/English-Literature/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page

	# Idioma 6 = Spanish
	# Idioma 7 = Catalan
	
	(1..40).each do |page|
		f.puts "http://www.casadellibro.com/busqueda-libros?spellcheck=1&page=#{page}&idcategoria=117000000&idioma=6&ordenar=1&idtipoproducto=1&itemxpagina=60&nivel=2"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"
