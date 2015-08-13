require 'amatch'
require 'namae'
require 'awesome_print'


author_name_to_query = [ ARGV[0], ARGV[1], ARGV[2], ARGV[3] ].join(' ').rstrip!

authors = []

File.readlines('/Users/jungdolee/projects/importer/data/author_name_source.txt', encoding: 'UTF-8'). each do |line|
	line.rstrip!
	authors << line
end


array = []

authors.each do |author|
	row = {}

	names = Namae.parse(author)
	names_queried = Namae.parse(author_name_to_query)

	row[:name] = author
	row[:given_name] = names[0].given
	row[:given_name_initial] = names[0].given[0]
	row[:family_name] = names[0].family

	row[:full_name_q] = author_name_to_query
	row[:given_name_q] = names_queried[0].given
	row[:given_name_initial_q] = names_queried[0].given[0]
	row[:family_name_q] = names_queried[0].family

	row[:similarity_given_name] = row[:given_name].to_s.levenshtein_similar(row[:given_name_q]).round(2)
	row[:similarity_given_name_initial] = row[:given_name_initial].to_s.levenshtein_similar(row[:given_name_initial_q])
	row[:similarity_family_name] = row[:family_name].to_s.levenshtein_similar(row[:family_name_q]).round(2)

	#row[:similarity_overall_benchmark] = row[:name].to_s.pair_distance_similar(row[:full_name_q]).round(2)

	if row[:similarity_given_name_initial] == 1
		row[:similarity_overall] = 0.5 * row[:similarity_given_name] + 0.5 * row[:similarity_family_name]
	else
		row[:similarity_overall] = 0.8 * row[:similarity_given_name] + 0.2 * row[:similarity_family_name]
	end
	
	#row[:similarity_average] = (( row[:similarity_overall] #+ row[:similarity_overall_benchmark] ) / 2).round(2)

	

	array << row

end

ap array.sort_by{ |hash| hash[:similarity_overall] }.reverse.delete_if { |hash| hash[:similarity_overall] < 0.5 }.take(5)


