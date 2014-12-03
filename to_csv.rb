require 'rubygems'
require 'csv'
require 'json'

input = JSON.parse(File.open("data/it_url_results.json").read)
writer = CSV.open("data/it_url_results.csv", "w")
writer << input.flatten.to_csv