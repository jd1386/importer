
first_page = "http://www.bokkilden.no/SamboWeb/utvalg.do?term=klasse_kode%3AA5+AND+spraak%3ANorsk&order=DESC&side=0&antall=10&overskrift=Ungdomsb%C3%B8ker&sortering=utgittaar&retning=DESC"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(1..50).each do |page|
		f.puts "http://www.bokkilden.no/SamboWeb/utvalg.do?term=klasse_kode%3AA5+AND+spraak%3ANorsk&sort=utgittaar&order=DESC&side=0&antall=10&overskrift=Ungdomsb%C3%B8ker&nyside=#{page-1}"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"