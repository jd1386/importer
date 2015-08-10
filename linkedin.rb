require 'linkedin-scraper'

profile = Linkedin::Profile.get_profile("https://www.linkedin.com/profile/view?id=32462246&authType=name&authToken=U_Ta&trk=prof-sb-browse_map-name")

puts profile.first_name
puts profile.last_name
puts profile.inspect