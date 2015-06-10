
source = []

File.readlines("data/asin_source.txt").each do |line|
	source <<	line.rstrip
end

File.open("data/asin_results.txt", "w", encoding: "UTF-8") do |f|
	source.each do |asin_raw|
		asin_spotted = /ASIN(=|%3D)\w{10}/.match(asin_raw).to_s
		
		puts asin_cleaned = asin_spotted.sub(/ASIN(=|%3D)/, '')

		f.puts asin_cleaned
	end
end