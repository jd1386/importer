# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	(0..500).each do |page|
		f.puts "http://livraria.folha.com.br/livros/criancas/8?order=launch_date&sr=#{page * 12 + 1}"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"

