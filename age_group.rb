@settings = ARGV[0]

new_array = []

File.readlines("data/age_group_source.txt").each do |line|
	if @settings == "single"
		new_line = line.gsub!('a', '-').scan(/\d+ . \d+/)
		puts new_line
		
		splitted = new_line[0].split(" - ")
		splitted.sort_by!(&:to_i)
		puts splitted

		
		new_array << splitted
		

	elsif @settings == "multiple"

		new_line = line.scan(/\d+-\d+/).join("-")
		puts new_line
		
		splitted = new_line.split("-")
		splitted.sort_by!(&:to_i)
		puts splitted

		new_array << splitted
	end
	
	


end

print new_array
puts "Extracted #{new_array.size} age group elements"

File.open("data/age_group_results.txt", 'w') do |f|
	new_array.each do |age|
		puts "#{age.first} to #{age.last} years"
		f.puts "#{age.first} to #{age.last}"
	end

end

