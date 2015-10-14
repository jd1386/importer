require "csv"

### 
#
# Watch out for 'Edition'
#
###

# Incomplete!
def format_format(raw)
  raw ||= "N/A"

  if raw.include? "Taschenbuch"
    result = "Paperback"
  elsif result == "N/A"
    result = raw
  else
    result = "Something else"
  end
end

def format_age_groups(raw)
  result = raw.gsub("ab ", "From ").gsub("Jahren", "years") unless raw.nil?
end

def format_language(raw)
  raw ||= "N/A"

  if raw.include? "deutsch"
    result = "German"
  elsif raw.include? "something else"
    result = "Other"
  elsif raw == "N/A"
    result = raw
  end
    
end


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("AutorIn ", " || author=> ")
  new_line = new_line.gsub("Übersetzung ", " || translator=> ") 
  new_line = new_line.gsub("Seiten ", " || pages=> ") 
  new_line = new_line.gsub("EAN ", " || EAN=> ") 
  new_line = new_line.gsub("Sprache ", " || language=> ")
  new_line = new_line.gsub("erschienen bei ", " || publisher=> ") 
  new_line = new_line.gsub("Erscheinungsdatum ", " || pub_date=> ")
  new_line = new_line.gsub("Ursprungstitel ", " || original_title=> ")
  new_line = new_line.gsub("Kategorie ", " || category=> ")
  new_line = new_line.gsub("Altersfreigabe ", " || age_group=> ")
  

  ## Process 

  # Split each line with a delimiter and make it an array
  splitted_line = new_line.split(" || ") 

  # Drop empty line to clean up. 
  splitted_line.reject! { |i| i.empty? }

  book_array = []
  hash = Hash.new

  # After splitted, make a hash with key-value pairs with corresponding values
  splitted_line.each do |e|
  		key = e.split("=> ").first
  		value = e.split("=> ").last.chomp('').rstrip
  		hash[key] = value
  end

  # Try to convert/clean each value if needed.
  hash["Age_group"] = format_age_groups(hash["Age_group"])
  hash["Language"] = format_language(hash["Language"])
  

  # Save the hash to a book_array
  book_array << hash


  meta_all << book_array


  
end

# Print the results 
puts "\nSuccess! Converted #{ meta_all.size } lines"


## Save meta_all to CSV file
CSV.open("/Users/jungdolee/projects/importer/data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << [ "publisher", "author", "translator", "EAN", "pub_date", "pages", "language", "original_title", "category", "age_group", "edition" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "publisher", "author", "translator", "EAN", "pub_date", "pages", "language", "original_title", "category", "age_group", "edition" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"