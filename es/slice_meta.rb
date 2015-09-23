require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Nº de páginas: ", " || Pages=> ") 
  new_line = new_line.gsub(" Editorial: ", " || Publisher=> ") 
  new_line = new_line.gsub(" Lengua: ", " || Language=> ")
  new_line = new_line.gsub(" Encuadernación: ", " || Format=> ") 
  new_line = new_line.gsub(" ISBN: ", " || ISBN=> ")
  new_line = new_line.gsub(" Año edición: ", " || Pub_date=> ")
  new_line = new_line.gsub(" Plaza de edición: ", " || Pub_location=> ")
  

 ## Process 

# Split each line with a delimiter and make it an array
splitted_line = new_line.split(" || ") 

# Drop empty line to clean up. 
splitted_line.reject! { |i| i.empty? }

book_array = []
hash = Hash.new

# After splitted, make a hash with key-value pairs with corresponding values
splitted_line.each do |e|
		k = e.split("=> ").first
		v = e.split("=> ").last.chomp('').rstrip
		hash[k] = v
		puts hash
end

# Save the hash to a book_array
book_array << hash


meta_all << book_array


  
end

# Print the results 
puts "\nSuccess! Converted #{ meta_all.size } lines"


## Save meta_all to CSV file
CSV.open("/Users/jungdolee/projects/importer/data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << [ "Publisher", "Pub_date", "Pub_location", "Language", "ISBN", "Format", "Pages" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Publisher", "Pub_date", "Pub_location", "Language", "ISBN", "Format", "Pages" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"