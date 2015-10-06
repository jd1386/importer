
first_page = "http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd/N/60+8293/filter_showNA/true/sort/product_datum1/weergave/lijst/index.html?limit=1317+1296"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	f.puts first_page
	
	(2..20).each do |page|
		f.puts "http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd/N/60+8293/filter_showNA/true/page/#{page}/sort/product_datum1/weergave/lijst/index.html?limit=1317+1296"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"