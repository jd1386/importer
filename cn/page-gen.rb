<<-COMMENT

Children's Literature
	http://list.jd.com/list.html?cat=1713,3263,3394&page=1&area=1,72,4137,0&sort=sort_publishtime_desc&go=0&JL=4_8_0
Science & Encyclopedia
	http://list.jd.com/list.html?cat=1713,3263,3399&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Illustrated
	http://list.jd.com/list.html?cat=1713,3263,4761&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Hand / Games
	http://list.jd.com/list.html?cat=1713,3263,3396&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Children Enlightenment
	http://list.jd.com/list.html?cat=1713,3263,3395&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Intellectual Development
	http://list.jd.com/list.html?cat=1713,3263,3398&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Anime / Catoon
	http://list.jd.com/list.html?cat=1713,3263,3391&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Toys Book
	http://list.jd.com/list.html?cat=1713,3263,12081&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Inspirational / Growth
	http://list.jd.com/list.html?cat=1713,3263,3400&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Childhood Education
	http://list.jd.com/list.html?cat=1713,3263,3393&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Music / Dance
	http://list.jd.com/list.html?cat=1713,3263,3397&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Art / Calligraphy
	http://list.jd.com/list.html?cat=1713,3263,4762&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Children Sinology
	http://list.jd.com/list.html?cat=1713,3263,3392&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Children English
	http://list.jd.com/list.html?cat=1713,3263,3401&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Jokes / Humor
	http://list.jd.com/list.html?cat=1713,3263,4760&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0
Admission and teaching materials prepared
	http://list.jd.com/list.html?cat=1713,3263,4763&page=1&sort=sort_publishtime_desc&go=0&JL=4_8_0

--- Youth Literature
http://list.jd.com/list.html?cat=1713,3260&page=1&sort=sort_publishtime_desc&JL=4_8_0

COMMENT

# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(1..438).each do |page|
		f.puts "http://list.jd.com/list.html?cat=1713,3260&page=#{page}&sort=sort_publishtime_desc"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"