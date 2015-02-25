require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  # Author (Auteur)
  new_line = line.gsub("Auteur ", " || Author=> ")  	
  # Illustrator (Illustrator)
 	new_line = new_line.gsub("Illustrator ", " || Illustrator=> ")
  # Other Stakeholders (Overige betrokkenen)
 	new_line = new_line.gsub("Overige betrokkenen ", " || Other Stakeholders=> ")
 	# Kind (Soort)
 	new_line = new_line.gsub("Soort ", " || Kind=> ") 	
 	# Language (Taal)
	new_line = new_line.gsub("Taal ", " || Language=> ")
	# Original Title (Oorspronkelijke titel)
	new_line = new_line.gsub("Oorspronkelijke titel ", " || Original Title=> ")
	# Language Translated from (EAN)
	new_line = new_line.gsub("Vertaald uit het ", " || Language Translated From=> ")
	# Translator (Vertaald door)
	new_line = new_line.gsub("Vertaald door ", " || Translator=> ")
	# Size (Afmetingen)
	new_line = new_line.gsub("Afmetingen ", " || Size=> ")
	# Weight (Gewicht)
	new_line = new_line.gsub("Gewicht ", " || Weight=> ")
	# Age Group (Geschikt voor)
	new_line = new_line.gsub("Geschikt voor ", " || Age Group=> ")
	# Druk (Druk)
	new_line = new_line.gsub("Druk ", " || Druk=> ")
	# ISBN10 (ISBN10)
	new_line = new_line.gsub("ISBN10 ", " || ISBN10=> ")
	# ISBN (ISBN13)
	new_line = new_line.gsub("ISBN13 ", " || ISBN13=> ")

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
		v = e.split("=> ").last.chomp('')#.chop
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
CSV.open("data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << ["Author", "Illustrator", "Other Stakeholders", "Kind", "Language", "Original Title", "Language Translated From", "Translator", "Size", "Weight", "Age Group", "Druk", "ISBN10", "ISBN13"]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at("Author", "Illustrator", "Other Stakeholders", "Kind", "Language", "Original Title", "Language Translated From", "Translator", "Size", "Weight", "Age Group", "Druk", "ISBN10", "ISBN13")
  	i += 1
  end

end


# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"