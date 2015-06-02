require 'awesome_print'

array = []

File.readlines('data/test_source.txt').each do |line|
	new_line = line.rstrip.split(', ')
	array << new_line.reverse
	
end

ap array

File.open('data/test_results.txt', 'w') do |f|
	array.each do |categories|
		f.puts categories.join(", ")
	end
end