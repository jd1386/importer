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

 # Dostupnost: skladem Rok vydání: 2015 Vydal: Svojtka & Co.; Formát: 32 stran, 289 × 256 × 9 mm, vázaná – papírový potah EAN: 9788025616321 ISBN: 978-80-256-1632-1


  new_line = line.gsub("Produs publicat in ", " || Pub_year_publisher=> ")
  new_line = new_line.gsub("Data aparitiei: ", " || Pub_date=> ") 
  new_line = new_line.gsub("Colectia ", " || Series=> ") 
  new_line = new_line.gsub("Format: ", " || Format=> ")
  new_line = new_line.gsub("Tip coperta: ", " || Cover=> ") 
  new_line = new_line.gsub("Numar pagini: ", " || Pages=> ") 
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
  csv << [ "Pub_year_publisher", "Pub_date", "Series", "Format", "Cover", "Pages", "ISBN" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Pub_year_publisher", "Pub_date", "Series", "Format", "Cover", "Pages", "ISBN" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"