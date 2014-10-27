require 'rubygems'
require 'json'

data_rows_3 = []
data_rows_3 = [
  [

  ],
  [
    {
      "book_page_url/_text"=> "プラレール大集合 2015",
      "book_page_url/_title"=> "プラレール大集合 2015",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%83%97%E3%83%A9%E3%83%AC%E3%83%BC%E3%83%AB%E5%A4%A7%E9%9B%86%E5%90%88-2015-%E3%82%BF%E3%82%AB%E3%83%A9%E3%83%88%E3%83%9F%E3%83%BC/dp/4522433115/ref=sr_1_1?s=books&ie=UTF8&qid=1414329777&sr=1-1&keywords=9784522433119",
      "meta_all"=> "プラレール大集合 20152014/10/20 タカラトミー"
    }
  ],
  [
    {
      "book_page_url/_text"=> "どうぶつたちのあきのごちそう (サンチャイルド・ビッグサイエンス)",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%81%A9%E3%81%86%E3%81%B6%E3%81%A4%E3%81%9F%E3%81%A1%E3%81%AE%E3%81%82%E3%81%8D%E3%81%AE%E3%81%94%E3%81%A1%E3%81%9D%E3%81%86-%E3%82%B5%E3%83%B3%E3%83%81%E3%83%A3%E3%82%A4%E3%83%AB%E3%83%89%E3%83%BB%E3%83%93%E3%83%83%E3%82%B0%E3%82%B5%E3%82%A4%E3%82%A8%E3%83%B3%E3%82%B9-%E4%BB%8A%E6%B3%89%E5%BF%A0%E6%98%8E/dp/4805440163/ref=sr_1_1?s=books&ie=UTF8&qid=1414329779&sr=1-1&keywords=9784805440162",
      "meta_all"=> "どうぶつたちのあきのごちそう (サンチャイルド・ビッグサイエンス) 今泉忠明、 大久保茂徳 (2014/11)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "もののなまえ (はっけんずかんプチ)",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%82%82%E3%81%AE%E3%81%AE%E3%81%AA%E3%81%BE%E3%81%88-%E3%81%AF%E3%81%A3%E3%81%91%E3%82%93%E3%81%9A%E3%81%8B%E3%82%93%E3%83%97%E3%83%81-%E6%A8%AA%E5%B1%B1-%E6%B4%8B%E5%AD%90/dp/4052039912/ref=sr_1_1?s=books&ie=UTF8&qid=1414329780&sr=1-1&keywords=9784052039911",
      "meta_all"=> "もののなまえ (はっけんずかんプチ) 横山 洋子、こふじた はなえ、 かろくこうぼう (2014/10/14)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "女の子のなぞなぞ1・2年生 660問!",
      "book_page_url"=> "http://www.amazon.co.jp/%E5%A5%B3%E3%81%AE%E5%AD%90%E3%81%AE%E3%81%AA%E3%81%9E%E3%81%AA%E3%81%9E1%E3%83%BB2%E5%B9%B4%E7%94%9F-660%E5%95%8F-%E3%83%AA%E3%83%9C%E3%83%B3%E2%98%85%E3%83%8F%E3%82%A6%E3%82%B9/dp/4791621956/ref=sr_1_1?s=books&ie=UTF8&qid=1414329783&sr=1-1&keywords=9784791621958",
      "meta_all"=> "女の子のなぞなぞ1・2年生 660問! リボン★ハウス (2014/10/11)"
    }
  ],
  [

  ],
  [
    {
      "book_page_url/_text"=> "やさいとくだもの (はっけんずかんプチ)",
      "book_page_url/_title"=> "やさいとくだもの (はっけんずかんプチ)",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%82%84%E3%81%95%E3%81%84%E3%81%A8%E3%81%8F%E3%81%A0%E3%82%82%E3%81%AE-%E3%81%AF%E3%81%A3%E3%81%91%E3%82%93%E3%81%9A%E3%81%8B%E3%82%93%E3%83%97%E3%83%81-%E5%A5%A5%E5%B6%8B-%E4%BD%90%E5%92%8C%E5%AD%90/dp/4052039920/ref=sr_1_1?s=books&ie=UTF8&qid=1414329787&sr=1-1&keywords=9784052039928",
      "meta_all"=> "やさいとくだもの (はっけんずかんプチ)2014/10/14 奥嶋 佐和子、 ふじい かずえ"
    }
  ],
  [
    {
      "book_page_url/_text"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)",
      "book_page_url/_title"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%81%BE%E3%82%93%E3%81%8C%E3%81%A7%E8%AA%AD%E3%82%80-%E7%AB%B9%E5%8F%96%E7%89%A9%E8%AA%9E%E3%83%BB%E5%AE%87%E6%B2%BB%E6%8B%BE%E9%81%BA%E7%89%A9%E8%AA%9E-%E5%AD%A6%E7%A0%94%E3%81%BE%E3%82%93%E3%81%8C%E6%97%A5%E6%9C%AC%E3%81%AE%E5%8F%A4%E5%85%B8-%E8%B0%B7%E5%8F%A3-%E5%AD%9D%E4%BB%8B/dp/4052040007/ref=sr_1_1?s=books&ie=UTF8&qid=1414329788&sr=1-1&keywords=9784052040009",
      "meta_all"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)2014/10/14 谷口 孝介"
    }
  ],
  [
    {
      "book_page_url/_text"=> "10分で読める 憧れのあの人のサクセスストーリー",
      "book_page_url"=> "http://www.amazon.co.jp/10%E5%88%86%E3%81%A7%E8%AA%AD%E3%82%81%E3%82%8B-%E6%86%A7%E3%82%8C%E3%81%AE%E3%81%82%E3%81%AE%E4%BA%BA%E3%81%AE%E3%82%B5%E3%82%AF%E3%82%BB%E3%82%B9%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AA%E3%83%BC-%E3%82%B5%E3%82%AF%E3%82%BB%E3%82%B9%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AA%E3%83%BC%E7%A0%94%E7%A9%B6%E4%BC%9A/dp/4800233305/ref=sr_1_1?s=books&ie=UTF8&qid=1414329790&sr=1-1&keywords=9784800233301",
      "meta_all"=> "10分で読める 憧れのあの人のサクセスストーリー サクセスストーリー研究会 (2014/10/22)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ぼくはきみで きみはぼく",
      "book_page_url"=> "http://www.amazon.co.jp/%E3%81%BC%E3%81%8F%E3%81%AF%E3%81%8D%E3%81%BF%E3%81%A7-%E3%81%8D%E3%81%BF%E3%81%AF%E3%81%BC%E3%81%8F-%E3%83%AB%E3%83%BC%E3%82%B9%E3%83%BB%E3%82%AF%E3%83%A9%E3%82%A6%E3%82%B9/dp/4033482903/ref=sr_1_1?s=books&ie=UTF8&qid=1414329792&sr=1-1&keywords=9784033482903",
      "meta_all"=> "ぼくはきみで きみはぼく ルース・クラウス、モーリス・センダック、 江國 香織 (2014/10/22)"
    }
  ]
]


puts JSON.pretty_generate(data_rows_3)
puts data_rows_3.class
puts data_rows_3.size

#puts data_rows_3.inspect
data_rows_3[0][0]["book_page_url/_text"].nil?
puts data_rows_3[1][0]["book_page_url/_text"]
puts data_rows_3[2][0]["book_page_url/_text"]
puts data_rows_3[3][0]["book_page_url/_text"]
puts data_rows_3[4][0]["book_page_url/_text"]
puts data_rows_3[5][0]["book_page_url/_text"]
