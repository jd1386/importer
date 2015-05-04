# Run the following code and bulk upload them on import.io

File.open("data/de_recent_results.txt", "w") do |f|
  # First page
  #f.puts "http://www.mayersche.de/buecher/kinderbuch-jugendbuch/?sprache=ger&sortby=publicationdate&sortorder=desc"  

  # Second and up
  (1701..2000).each do |page|
    f.puts "http://www.mayersche.de/buecher/kinderbuch-jugendbuch/#{page}/?sprache=ger&sortby=publicationdate&sortorder=desc"
  end
end

# First page
# http://www.mayersche.de/buecher/kinderbuch-jugendbuch/?sprache=ger&sortby=publicationdate&sortorder=desc

# Second page and up
# http://www.mayersche.de/buecher/kinderbuch-jugendbuch/2/?sprache=ger&sortby=publicationdate&sortorder=desc