string = "4 to 6"
puts array = string.split(" to ")

new_array = []
(array.first..array.last).each do |age|
	
	new_array << age.to_i
end

print new_array