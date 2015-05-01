require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Country ", " || Country=> ") 
  new_line = new_line.gsub(" Agency Name ", " || Agency Name=> ") 
  new_line = new_line.gsub(" ISBN Prefix ", " || ISBN Prefix=> ")
  new_line = new_line.gsub(" Status ", " || Status=> ")
  new_line = new_line.gsub(" Address ", " || Address=> ")
  new_line = new_line.gsub(" Admin Contact Name ", " || Admin Contact Name=> ")
  new_line = new_line.gsub(" Web Site ", " || Web Site=> ")
  new_line = new_line.gsub(" san ", " || san=> ")
  new_line = new_line.gsub(" Admin Phone ", " || Admin Phone=> ")
  new_line = new_line.gsub(" Admin Fax ", " || Admin Fax=> ")
  new_line = new_line.gsub(" Admin Email ", " || Admin Email=> ")
  new_line = new_line.gsub(" Alternate Contact Name ", " || Alternate Contact Name=> ")
  new_line = new_line.gsub(" Alternate Phone ", " || Alternate Phone=> ")
  new_line = new_line.gsub(" Alternate Fax ", " || Alternate Fax=> ")
  new_line = new_line.gsub(" Alternate Email ", " || Alternate Email=> ")
  
  

  

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
CSV.open("data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << [ "Country", "Agency Name", "ISBN Prefix", "Status", "Address", "Admin Contact Name", "Web Site", "san", "Admin Phone", "Admin Fax", "Admin Email", "Alternate Contact Name", "Alternate Phone", "Alternate Fax", "Alternate Email" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Country", "Agency Name", "ISBN Prefix", "Status", "Address", "Admin Contact Name", "Web Site", "san", "Admin Phone", "Admin Fax", "Admin Email", "Alternate Contact Name", "Alternate Phone", "Alternate Fax", "Alternate Email" ) 
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"