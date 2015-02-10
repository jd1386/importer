require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  # Author (AutorIn)
  new_line = line.gsub("AutorIn ", " || Author=> ")  	
  # Translator (Übersetzung)
 	new_line = new_line.gsub("Übersetzung ", " || Translator=> ")
 	# Edition (Edition)
  new_line = new_line.gsub("Edition ", " || Edition=> ")
 	# Page (Seiten)
	new_line = new_line.gsub("Seiten ", " || Page=> ")
	# ISBN (EAN)
	new_line = new_line.gsub("EAN ", " || ISBN=> ")
	# Language (Sprache)
	new_line = new_line.gsub("Sprache ", " || Language=> ")
	# Publisher (erschienen bei)
	new_line = new_line.gsub("erschienen bei ", " || Publisher=> ")
	# Pub Date (Erscheinungsdatum)
	new_line = new_line.gsub("Erscheinungsdatum ", " || Pub_Date=> ")
	# Category (Kategorie)
	new_line = new_line.gsub("Kategorie ", " || Category=> ")
	# Age Group (Altersfreigabe)
	new_line = new_line.gsub("Altersfreigabe ", " || Age_Group=> ")
	# Original Title(Ursprungstitel)
	new_line = new_line.gsub("Ursprungstitel ", " || Original_Title=> ")
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
		v = e.split("=> ").last.chomp('').chop
		hash[k] = v
end

# Save the hash to a book_array
book_array << hash


meta_all << book_array


  
end

# Print the results 
puts meta_all
puts "\nSuccess! Converted #{ meta_all.size } lines"


## Save meta_all to CSV file
CSV.open("data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << ["Author", "Translator", "Edition", "Page", "ISBN", "Language", "Publisher", "Pub_Date", "Category", "Age_Group", "Original_Title"]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at("Author", "Translator", "Edition", "Page", "ISBN", "Language", "Publisher", "Pub_Date", "Category", "Age_Group", "Original_Title")
  	i += 1
  end

end


# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"