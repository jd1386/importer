require 'base64'

str = 'I Love You Heawon'

puts 'Original str is ' + str

encoded = Base64.encode64(str)
puts 'Encoded str is ' + encoded

decoded = Base64.decode64(encoded)
puts 'Decoded str is ' + decoded 