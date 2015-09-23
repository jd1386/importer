require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Date de parution : ", " || Pub_date=> ") 
  new_line = new_line.gsub(" Editeur : ", " || Publisher=> ") 
  new_line = new_line.gsub(" Collection : ", " || Series=> ")
  new_line = new_line.gsub(" ISBN : ", " || ISBN=> ") 
  new_line = new_line.gsub(" EAN : ", " || EAN=> ")
  new_line = new_line.gsub(" Format : ", " || Format_1=> ")
  new_line = new_line.gsub(" Présentation : ", " || Format_2=> ")
  new_line = new_line.gsub(" Poids : ", " || Weight=> ")
  new_line = new_line.gsub(" Nb. de pages : ", " || Pages=> ")
  new_line = new_line.gsub(" Dimensions : ", " || Dimensions=> ")
  #new_line = new_line.gsub(/ \| \d{0,9} pages/) { |string| " || Page=> #{string.gsub(' | ', '')}" }
  
  

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
  csv << [ "Pub_date", "Publisher", "ISBN", "EAN", "Series", "Format_1", "Format_2", "Weight", "Pages", "Dimensions" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Pub_date", "Publisher", "ISBN", "EAN", "Series", "Format_1", "Format_2", "Weight", "Pages", "Dimensions" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"