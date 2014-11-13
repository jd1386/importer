require 'csv'
require 'json'

file = 'data/italy_buyers_part_1.json'

json = JSON.parse(File.open(file).read)
puts json.first.collect {|k,v| k}.join(',')
puts json.collect {|node| "#{node.collect{|k,v| v}.join(',')}\n"}.join
