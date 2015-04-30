require 'Vacuum'
require 'dotenv'
require 'awesome_print'

Dotenv.load


request = Vacuum.new('ES')
request.configure(
	aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
	aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
	associate_tag: ENV['AWS_ASSOCIATE_TAG']
)

response = request.item_lookup(
  query: {
    'IdType' => 'ISBN',
    'ItemId' => 9788427200388,
    'SearchIndex' => 'Books',
    'ResponseGroup' => 'Large'
  }
)

parsed_response = response.to_h
ap parsed_response["ItemLookupResponse"]["Items"]["Item"]

