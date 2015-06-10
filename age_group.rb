@settings = ARGV[0]

new_array = []

File.readlines("data/age_group_source.txt").each do |line|
	if @settings == "single"
		if line.scan(/\d+ - \d+/)[0].nil?
			puts "No integer in the given string!"
			new_array << nil

		else
			new_line = line.gsub!('-', '-').scan(/\d+ - \d+/)
			puts new_line
			
			splitted = new_line[0].split(" - ")
			splitted.sort_by!(&:to_i)

			new_array << splitted
		end
		

	elsif @settings == "multiple"
		if line.scan(/\d+-\d+/)[0].nil?
			puts "No integer in the given string!"
			new_array << ''

		else
			new_line = line.scan(/\d+-\d+/).join("-")
			puts new_line
			
			splitted = new_line.split("-")
			splitted.sort_by!(&:to_i)

			new_array << splitted
		end
	end
	
	


end

print new_array
puts "Extracted #{new_array.size} age group elements"

File.open("data/age_group_results.txt", 'w') do |f|
	new_array.each do |age|
		if age.nil?
			f.puts ""

		else
			puts "#{age.first} to #{age.last} years"
			f.puts "#{age.first} to #{age.last}"
		end
	end

end

