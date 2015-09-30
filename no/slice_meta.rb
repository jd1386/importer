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

 # Utgitt: 2015 Forlag: Norsk forl. Innbinding: Kartonert Språk: Norsk ISBN: 9788278884232 Utgave: 1. utg. Alder: Barn 0-3 Format: 25 x 16 cm KATEGORIER: Zoologi og dyr Bla i alle kategorier



  new_line = line.gsub("Utgitt: ", " || Pub_date=> ")
  new_line = new_line.gsub("Forlag: ", " || Publisher=> ") 
  new_line = new_line.gsub("Innbinding: ", " || Binding=> ") 
  new_line = new_line.gsub("Språk: ", " || Language=> ")
  new_line = new_line.gsub("Sider: ", " || Pages=> ")
  new_line = new_line.gsub("ISBN: ", " || ISBN=> ") 
  new_line = new_line.gsub("Utgave: ", " || Edition=> ") 
  new_line = new_line.gsub("Orig.tittel: ", " || Original_title=> ") 

  
  new_line = new_line.gsub("Alder: ", " || Age_group=> ") 
  new_line = new_line.gsub("Format: ", " || Format=> ") 
  new_line = new_line.gsub("SERIE: ", " || Series=> ") 
  new_line = new_line.gsub("KATEGORIER: ", " || Categories=> ") 



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
  csv << [ "Pub_date", "Publisher", "Binding", "Language", "Pages", "ISBN", "Edition", "Original_title", "Age_group", "Format", "Series", "Categories" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Pub_date", "Publisher", "Binding", "Language", "Pages", "ISBN", "Edition", "Original_title", "Age_group", "Format", "Series", "Categories" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"