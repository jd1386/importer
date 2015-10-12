require "csv"

### 
#
# 
#
###

def format_age_groups(raw)  
  result = case raw
    when "0-3 år" then "0-3 years"
    when "3-6 år" then "3-6 years"
    when "6-9 år" then "6-9 years"
    when "9-12 år" then "9-12 years"
    when "12-15 år" then "12-15 years"
    when "Unga vuxna" then "YA"
  end

  return result
end

def format_type(raw)
  if raw.include? "Ljudbok" 
    result = "Musicbook"
  elsif raw.include? "Häftad" 
    result = "Paperback"
  elsif raw.include? "Inbunden"
    result = "Hardcover"
  elsif raw.include? "Kartonnage"
    result = "Boardbook"
  elsif raw.include? "Mp3-bok"
    result = "MP3 Book"
  elsif raw.include? "Övrigt"
    result = "Other"
  elsif raw.nil?
    result = ""
  else
    result = "Other"
  end
    
  return result
end


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
  new_line = new_line.gsub("Dimensioner: ", " || Dimension=> ") 
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
		key = e.split("=> ").first
		value = e.split("=> ").last.chomp('').rstrip
		hash[key] = value
  end

  # Try to convert/clean each value if needed.
  hash["Age_group"] = format_age_groups(hash["Age_group"])
  hash["Format"] = format_type(hash["Format"]) unless hash["Format"].nil?



  # Save the hash to a book_array
  book_array << hash


  meta_all << book_array


  
end

# Print the results 
puts "\nSuccess! Converted #{ meta_all.size } lines"


## Save meta_all to CSV file
CSV.open("/Users/jungdolee/projects/importer/data/to_hash_results.csv", "w") do |csv|
	# Write header
  csv << [ "Format", "Language", "Series", "Age_group", "Pages", "Pub_date", "Edition", "Publisher", "Translator", "Original_title", "Illustrator/Photographer", "ISBN" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
  	csv << meta_all[i][0].values_at( "Format", "Language", "Series", "Age_group", "Pages", "Pub_date", "Edition", "Publisher", "Translator", "Original_title", "Illustrator/Photographer", "ISBN" )
  	i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"