require 'csv'
require 'namae'

def extract_authors
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

				# Add dot if initials
				# Case 1: J D Salinger => J. D. Salinger
				if given_name && given_name.split(' ')[0].size == 1
					dotted_given_names = []

					(0...given_name.split(' ').size).each do |i|
						
						dotted_given_names << "#{given_name.split(' ')[i]}."
					end
					given_name = dotted_given_names.join(' ')

				# Case 2: Jerome D Salinger => Jerome D. Salinger
				# elsif given_name && given_name.split(' ')[1].size == 1
					
				# 	given_name = given_name.split(' ')[0] + "#{given_name.split(' ')[1]}." + given_name.split(' ').last
				end


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
end

def separate_given_names
	File.readlines('/Users/jungdolee/projects/importer/data/slice_authors_source.txt', encoding: 'UTF-8').each do |given_names|
		
		names = given_names.split
		first_name = names[0]
		# if single middle names
		if names.size == 2
			middle_names = names[1]

		# if middle_names
		elsif names.size > 2
			middle_names = []
			(1...names.size).each do |i|
				middle_names << names[i]
			end
			middle_names = middle_names.join(' ')
		end

		# Let's write the results to csv
		CSV.open('/Users/jungdolee/projects/importer/data/slice_authors_results.csv', 'a', encoding: 'UTF-8') do |csv|

			# Rows
			csv << [ first_name, middle_names ]

		end




	end
	
end

separate_given_names