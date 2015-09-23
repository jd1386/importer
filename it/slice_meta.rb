require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Generi ", " || Category=> ") 
  new_line = new_line.gsub(" Editore ", " || Publisher=> ") 
  new_line = new_line.gsub(" Collana ", " || Collection=> ")
  new_line = new_line.gsub(" Formato ", " || Format=> ")
  new_line = new_line.gsub(" Pubblicato ", " || Pub_date=> ") 
  new_line = new_line.gsub(" Pagine ", " || Pages=> ")
  new_line = new_line.gsub(" Lingua ", " || Language=> ")
  new_line = new_line.gsub(" Titolo Originale ", " || Original_title=> ")
  new_line = new_line.gsub(" Originale ", " || Original_language=> ")
  new_line = new_line.gsub(" ISBN-13 ", " || ISBN=> ")
  new_line = new_line.gsub(" Illustratore ", " || Illustrator=> ")
  new_line = new_line.gsub(" Curatore ", " || Curator=> ")
  new_line = new_line.gsub(" Traduttore ", " || Translator=> ")

  

  

  
  

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
  csv << [ "Publisher", "Pub_date", "ISBN", "Collection", "Format", "Pages", "Language", "Original_title", "Original_language", "Illustrator", "Curator", "Translator", "Category" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Publisher", "Pub_date", "ISBN", "Collection", "Format", "Pages", "Language", "Original_title", "Original_language", "Illustrator", "Curator", "Translator", "Category" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"