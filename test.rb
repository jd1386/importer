string = "http://www.lafeltrinelli.it/libri/aaron-becker/viaggio/9788807922435"

puts string

new_string = string.gsub(/978(?:-?\d){10}/, '')

puts new_string