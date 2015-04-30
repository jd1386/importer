require 'Vacuum'
require 'awesome_print'


request = Vacuum.new('ES')
request.configure(
	aws_access_key_id: 'AKIAJPFH4EM4BZ74GXGA',
	aws_secret_access_key: '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',
	associate_tag: 'origh-20'
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
ap parsed_response["ItemLookupResponse"]["Items"]["Item"].keys

ap parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"].size
