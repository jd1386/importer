require 'google-search'
require 'awesome_print'

def books_by(author)
	results = []

	Google::Search::Book.new(query: author).each do |result|
		meta = []

		title = result.title
		author = result.author
		pub_date = result.published_year
		id = result.id
		url = result.uri
		cover_image = result.thumbnail_uri
		page = result.pages

		###

		meta << [ title, pub_date, author, id, url, cover_image, page ]
		results << meta
		
	end

	ap results.sort_by { |m| m[0][1] }.reverse	
end

def author(author, role)
	results = []


	Google::Search::Web.new(query: [author, role].join(' ')).each_with_index do |result, index|
		row = []
		meta = {}

		meta[:title] = title = result.title
		meta[:visible_uri] = result.visible_uri
		meta[:content] = result.content
		meta[:url] = result.uri

		###

		row << meta
		results << row

		break if index == 8
	end

	ap results
	
end


#search_books_by_author('Linda Chapman')
search_author('Linda Chapman', 'Author')

