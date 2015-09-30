require "csv"

### 
#
# 
#
###


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Format: ", " || Format=> ")
  new_line = new_line.gsub("Språk: ", " || Language=> ") 
  new_line = new_line.gsub("Serie: ", " || Series=> ") 
  new_line = new_line.gsub("Läsålder: ", " || Age_group=> ") 
  new_line = new_line.gsub("Antal sidor: ", " || Pages=> ") 
  new_line = new_line.gsub("Inläsare: ", " || Inläsare=> ") 
  new_line = new_line.gsub("Utg.datum: ", " || Pub_date=> ") 
  new_line = new_line.gsub("Upplaga: ", " || Edition=> ") 
  new_line = new_line.gsub("Förlag: ", " || Publisher=> ") 
  new_line = new_line.gsub("Medarbetare: ", " || Medarbetare=> ") 
  new_line = new_line.gsub("SAB: ", " || SAB=> ") 
  new_line = new_line.gsub("Översättare: ", " || Translator=> ") 
  new_line = new_line.gsub("Originaltitel: ", " || Original_title=> ") 
  new_line = new_line.gsub("Illustratör/Fotograf: ", " || Illustrator/Photographer=> ") 
  new_line = new_line.gsub("ISBN: ", " || ISBN=> ") 
  


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
  csv << [ "Format", "Language", "Series", "Age_group", "Pages", "Inläsare", "Pub_date", "Edition", "Publisher", "Medarbetare", "SAB", "Translator", "Original_title", "Illustrator/Photographer", "ISBN" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Format", "Language", "Series", "Age_group", "Pages", "Inläsare", "Pub_date", "Edition", "Publisher", "Medarbetare", "SAB", "Translator", "Original_title", "Illustrator/Photographer", "ISBN" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"