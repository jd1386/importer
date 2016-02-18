# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	(101..160).each do |page|
		f.puts "http://www.fnac.pt/n690293/Todos-os-Livros-Infantis?sl=-1.0&PageIndex=#{page}&ItemPerPage=15&ssi=2&sso=2&sa=1"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"
