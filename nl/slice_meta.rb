require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Auteur ", " || Author=> ") 
  new_line = new_line.gsub(" Co-auteur ", " || Co-author=> ") 
  new_line = new_line.gsub(" Soort ", " || Type=> ") 
  new_line = new_line.gsub(" Taal ", " || Language=> ") 
  new_line = new_line.gsub(" Vertaald door ", " || Translator=> ") 
  new_line = new_line.gsub(" Geschikt voor ", " || Age_group=> ") 
  new_line = new_line.gsub(" Gewicht ", " || Weight=> ") 
  new_line = new_line.gsub(" Afmetingen ", " || Dimensions=> ") 
  new_line = new_line.gsub(" Illustrator ", " || Illustrator=> ") 
  new_line = new_line.gsub(" Overige betrokkenen ", " || Other_contributor=> ") 
  new_line = new_line.gsub(" Vertaald uit ", " || Translated_from=> ")
  new_line = new_line.gsub(" Oorspronkelijke titel ", " || Original_title=> ")
  new_line = new_line.gsub(" Druk ", " || Edition=> ")
  new_line = new_line.gsub(" ISBN10 ", " || ISBN10=> ") 
  new_line = new_line.gsub(" ISBN13 ", " || ISBN13=> ")
  new_line = new_line.gsub(" Product breedte ", " || Product_width=> ")
  new_line = new_line.gsub(" Product hoogte ", " || Product_height=> ")
  new_line = new_line.gsub(" Product lengte ", " || Product_length=> ")



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
  csv << [ "Author", "Co-author", "Type", "Language", "Translator", "Age_group", "Weight", "Dimensions", "Illustrator", "Other_contributor", "Translated_from", "Original_title", "Edition", "ISBN10", "ISBN13", "Product_width", "Product_height", "Product_length" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Author", "Co-author", "Type", "Language", "Translator", "Age_group", "Weight", "Dimensions", "Illustrator", "Other_contributor", "Translated_from", "Original_title", "Edition", "ISBN10", "ISBN13", "Product_width", "Product_height", "Product_length" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"