require "csv"


# Read source file and clean up each line
meta_all = []

File.readlines('data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Utgitt: ", " || Pub_Date=> ")  	
  new_line = new_line.gsub("Forlag: ", " || Publisher=> ")
  new_line = new_line.gsub("Innb: ", " || Format=> ")
 	new_line = new_line.gsub("Språk: ", " || Language=> ")
 	new_line = new_line.gsub("Sider: ", " || Sider=> ")
	new_line = new_line.gsub("Format: ", " || Size=> ")
	new_line = new_line.gsub("Utgave: ", " || Edition=> ")
	new_line = new_line.gsub("Genre: ", " || Category=> ")
	new_line = new_line.gsub("Emne: ", " || Topic=> ")
	new_line = new_line.gsub("Alder: ", " || Age_Group=> ")
	new_line = new_line.gsub("Serie: ", " || Series=> ")
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
CSV.open("data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << ["Pub_Date", "Publisher", "Format", "Language", "Size", "Edition", "Category", "Topic", "Age_Group", "Series", "ISBN"]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at("Pub_Date", "Publisher", "Format", "Language", "Size", "Edition", "Category", "Topic", "Age_Group", "Series", "ISBN")
  	i += 1
  end

end


# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"