<<-CATEGORIES

books.com.tw:
	0-3 year-old infant: 								http://www.books.com.tw/web/books_bmidm_1401
	word cards / exercise books: 				http://www.books.com.tw/web/books_bmidm_1402
	Game Book: 													http://www.books.com.tw/web/books_bmidm_1403
	Picture Book: 											http://www.books.com.tw/web/books_bmidm_1404
	Children's Literature: 							http://www.books.com.tw/web/books_bmidm_1405
	Children's Stories / Novels: 				http://www.books.com.tw/web/books_bmidm_1406
	History / Biography: 								http://www.books.com.tw/web/books_bmidm_1407
	Science / Encyclopedia: 						http://www.books.com.tw/web/books_bmidm_1408
	Art & Craft: 											 	http://www.books.com.tw/web/books_bmidm_1409
	Knowledge Learning Comics:					http://www.books.com.tw/web/books_bmidm_1410
	Language Learning: 									http://www.books.com.tw/web/books_bmidm_1411
	Youth Literature: 									http://www.books.com.tw/web/books_bmidm_1412
	Young Adult Fiction: 								http://www.books.com.tw/web/books_bmidm_1413

CATEGORIES



# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page

	(1..620).each do |page|
		f.puts "http://www.books.com.tw/web/books_bmidm_#{category_num}/?o=1&v=1&page=1"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"