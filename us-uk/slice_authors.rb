require 'csv'
require 'namae'

@authors = []

File.readlines('/Users/jungdolee/projects/importer/data/slice_authors_source.txt', encoding: 'UTF-8'). each do |line|
	contributors = line.split(', ')
	
	(0...contributors.size).each do |i|
		
		# We want to get only authors not other roles
		if contributors[i].include?(" (author) ")
			@authors << contributors[i].rstrip
		
		# Skip if there is any translator; she's not an English-speaking author
		elsif contributors[i].include?("Translated by")
			next
		end
	end

	#puts @authors.inspect



end

@authors = @authors.flatten.sort.uniq
puts @authors
@authors_size = @authors.size


# Let's write the results to csv
CSV.open('/Users/jungdolee/projects/importer/data/slice_authors_results.csv', 'w', encoding: 'UTF-8') do |csv|
	# Header
	csv << [ "Title", "Appellation", "Given Name", "Name Particle", "Nickname", "Family Name", "Raw Full Name", "Cleaned Full Name", "Role", "Language" ]

	@authors.each do |author|
	
		names_raw = author.gsub!("By (author) ", "")
		names = Namae.parse(names_raw)
		
		if names.empty?
			next
		else
			title = names[0].title
			appellation = names[0].appellation
			given_name = names[0].given
			name_particle = names[0].particle
			nick_name = names[0].nick
			family_name = names[0].family
			if name_particle
				cleaned_full_name = [ given_name, name_particle, family_name ].join(' ')
			else
				cleaned_full_name = [ given_name, family_name ].join(' ')
			end
			role = 'Author'
			language = 'English'
		end
	
	# Rows
	csv << [ title, appellation, given_name, name_particle, nick_name, family_name, names_raw, cleaned_full_name, role, language ]
			
	end

end

puts "All done."