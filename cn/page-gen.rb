<<-COMMENT

Children's
	http://list.jd.com/list.html?cat=1713,3263&page=1&sort=sort_publishtime_desc&JL=4_8_0
Youth Literature
	http://list.jd.com/list.html?cat=1713,3260&page=1&sort=sort_publishtime_desc&JL=4_8_0

COMMENT

# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(1..485).each do |page|
		f.puts "http://list.jd.com/list.html?cat=1713,3263&page=#{page}&sort=sort_publishtime_desc"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"