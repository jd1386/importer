require 'Vacuum'


request = Vacuum.new('ES')
request.configure(
	aws_access_key_id: 'AKIAJPFH4EM4BZ74GXGA',
	aws_secret_access_key: '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',
	associate_tag: 'origh-20'
)

response = request.item_lookup(
  query: {
    'IdType' => 'ISBN',
    'ItemId' => 9788467043563,
    'SearchIndex' => 'Books',
    'ResponseGroup' => 'Small'
  }
)

parsed_response = response.to_h
puts parsed_response["ItemLookupResponse"]["Items"]["Item"]