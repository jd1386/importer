require 'amatch'


puts "Hans Chrstian Andersen".pair_distance_similar("Hans Kimberly") # 0.29
puts "Hans Chrstian Andersen".pair_distance_similar("Anderson") # 0.41
puts "Hans Chrstian Andersen".pair_distance_similar("H. C. Andersen") # 0.53
puts "Hans Chrstian Andersen".pair_distance_similar("H. Andersen") # 0.56
puts "Hans Chrstian Andersen".pair_distance_similar("Hans Anderson") # 0.59
puts "Hans Chrstian Andersen".pair_distance_similar("Hans C. Anderson") # 0.57
puts "Hans Chrstian Andersen".pair_distance_similar("Andersen, Hans") # 0.71
puts "Hans Chrstian Andersen".pair_distance_similar("Hans Chrstian Andersen") # 1.0


puts "Hans C. Andersen".pair_distance_similar("Hans Chrstian Andersen") # 0.71

puts "G. Stilton".pair_distance_similar("Geronimo Stilton") # 0.6
