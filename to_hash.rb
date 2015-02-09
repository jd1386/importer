# Read source file and hash-fy each line
meta_all = []
File.open('data/to_hash_source.txt', encoding: 'UTF-8').each_line do |line|
	new_line = line.gsub("Edition ", "Edition => ")
  new_line = new_line.gsub("AutorIn ", "Author => ")
 	new_line = new_line.gsub("Übersetzung ", "Translator => ")
	new_line = new_line.gsub("Seiten ", "Page => ")
	new_line = new_line.gsub("EAN ", "ISBN => ")
	new_line = new_line.gsub("Sprache ", "Language => ")
	new_line = new_line.gsub("erschienen bei ", "Publisher => ")
	new_line = new_line.gsub("Erscheinungsdatum ", "Pub_Date => ")
	new_line = new_line.gsub("Kategorie ", "Category => ")
	new_line = new_line.gsub("Altersfreigabe ", "Age_Group => ")

new_line = new_line.split("||")
new_line.delete_if { new_line[0].length == 0 }

puts new_line
puts "\n"
meta_all << new_line

#h = Hash[new_line.each_slice(2).to_a]
#puts h
#puts h.class
  
end

puts meta_all.size
puts meta_all[0]
puts meta_all[1]

abort

# Try to convert each line to hash
hash_all = []

meta_all.each do |meta|
	hash_all << Hash.try_convert(meta)
end

puts hash_all
