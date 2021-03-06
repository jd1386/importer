require "csv"
require "awesome_print"

### 
#
# 
#
###

def format_date(raw, month)
  year = raw.split(" ").last
  result = "01/#{month}/#{year}"
  return result
end


def format_pub_date(raw)
  if raw.include? "janeiro"
    month = "01"
    result = format_date(raw, month)
  elsif raw.include? "fevereiro" 
    month = "02"
    result = format_date(raw, month)
  elsif raw.include? "março" # March
    month = "03"
    result = format_date(raw, month)
  elsif raw.include? "abril" # April
    month = "04"
    result = format_date(raw, month)
  elsif raw.include? "maio" # May
    month = "05"
    result = format_date(raw, month)
  elsif raw.include? "junho" # June
    month = "06"
    result = format_date(raw, month)
  elsif raw.include? "julho" # July
    month = "07"
    result = format_date(raw, month)
  elsif raw.include? "agosto" # August
    month = "08"
    result = format_date(raw, month)
  elsif raw.include? "setembro" # September
    month = "09"
    result = format_date(raw, month)
  elsif raw.include? "outubro" # October
    month = "10"
    result = format_date(raw, month)
  elsif raw.include? "novembro" # November
    month = "11"
    result = format_date(raw, month)
  elsif raw.include? "dezembro" # December
    month = "12"
    result = format_date(raw, month)
  else
    result = raw
  end
    
  return result
end

def reformat_pub_date(formatted_date)
  day = formatted_date.split("/")[0]
  month = formatted_date.split("/")[1]
  year = formatted_date.split("/")[2]
  return "#{year}-#{month}-#{day}"
end


# Read source file and clean up each line
meta_all = []

File.readlines('/Users/jungdolee/projects/importer/data/to_hash_source.txt', encoding: 'UTF-8').each do |line|
 ## Pre-process

  new_line = line.gsub("Título : ", " || Title=> ")
  new_line = new_line.gsub("Subtítulo : ", " || Subtitle=> ") 
  new_line = new_line.gsub("Autor : ", " || Authors=> ") 
  new_line = new_line.gsub("Ilustração : ", " || Illustrator=> ") 
  new_line = new_line.gsub("Adaptação : ", " || Adaptation=> ") 
  new_line = new_line.gsub("Organizador : ", " || Organizor=> ") 
  new_line = new_line.gsub("Seleção : ", " || Selection=> ") 
  new_line = new_line.gsub("  Editora : ", " || Publisher=> ") 
  new_line = new_line.gsub("Tradução : ", " || Translator=> ") 
  new_line = new_line.gsub("Edição : ", " || Edition=> ") 
  new_line = new_line.gsub("Ano : ", " || Pub_year=> ") 
  new_line = new_line.gsub("Idioma : ", " || Language=> ") 
  new_line = new_line.gsub("Especificações : ", " || Binding=> ") 
  new_line = new_line.gsub(" | ", " || Pages=> ") 
  new_line = new_line.gsub("ISBN : ", " || ISBN=> ") 
  new_line = new_line.gsub("Peso : ", " || Weight=> ") 
  new_line = new_line.gsub("Dimensões : ", " || Dimension=> ") 
  new_line = new_line.gsub("Coleção :", " || Collection=> ") 

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
  hash["Pub_date"] = format_pub_date(hash["Pub_date"]) unless hash["Pub_date"].nil?
  hash["Pub_date"] = reformat_pub_date(hash["Pub_date"]) unless hash["Pub_date"].nil?



  # Save the hash to a book_array
  book_array << hash

  ap hash

  meta_all << book_array


  
end

# Print the results 
puts "\nSuccess! Converted #{ meta_all.size } lines"

## Save meta_all to CSV file
CSV.open("/Users/jungdolee/projects/importer/data/to_hash_results.csv", "w") do |csv|
  # Write header
  csv << [ "Title", "Subtitle", "Authors", "Illustrator", "Adaptation", "Organizor", "Selection", "Publisher", "Translator", "Edition", "Pub_year", "Language", "ISBN", "Pages", "Binding", "Weight", "Dimension", "Collection" ]

  # Write rows
  i = 0

  (0...meta_all.length).each do 
    csv << meta_all[i][0].values_at( "Title", "Subtitle", "Authors", "Illustrator", "Adaptation", "Organizor", "Selection", "Publisher", "Translator", "Edition", "Pub_year", "Language", "ISBN", "Pages", "Binding", "Weight", "Dimension", "Collection" )
    i += 1
  end

end

# Print the results 
puts "Success! Saved the results to data/to_hash_results.csv"