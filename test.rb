require 'rubygems'
require 'json'

data_rows_3 = []
data_rows_3 = [
  [
    {
      "book_page_url/_text"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)",
      "book_page_url/_title"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%BE%E3%82%93%E3%81%8C%E3%81%A7%E8%AA%AD%E3%82%80-%E7%AB%B9%E5%8F%96%E7%89%A9%E8%AA%9E%E3%83%BB%E5%AE%87%E6%B2%BB%E6%8B%BE%E9%81%BA%E7%89%A9%E8%AA%9E-%E5%AD%A6%E7%A0%94%E3%81%BE%E3%82%93%E3%81%8C%E6%97%A5%E6%9C%AC%E3%81%AE%E5%8F%A4%E5%85%B8-%E8%B0%B7%E5%8F%A3-%E5%AD%9D%E4%BB%8B/dp/4052040007/ref=sr_1_1?s=books&ie=UTF8&qid=1414478519&sr=1-1&keywords=9784052040009",
      "meta_all"=> "まんがで読む 竹取物語・宇治拾遺物語 (学研まんが日本の古典)2014/10/14 谷口 孝介"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ぼくのレオおじさん=> ルーマニア・アルノカ平原のぼうけん",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%BC%E3%81%8F%E3%81%AE%E3%83%AC%E3%82%AA%E3%81%8A%E3%81%98%E3%81%95%E3%82%93-%E3%83%AB%E3%83%BC%E3%83%9E%E3%83%8B%E3%82%A2%E3%83%BB%E3%82%A2%E3%83%AB%E3%83%8E%E3%82%AB%E5%B9%B3%E5%8E%9F%E3%81%AE%E3%81%BC%E3%81%86%E3%81%91%E3%82%93-%E3%83%A4%E3%83%8D%E3%83%83%E3%83%84-%E3%83%AC%E3%83%B4%E3%82%A3/dp/4052040341/ref=sr_1_1?s=books&ie=UTF8&qid=1414478519&sr=1-1&keywords=9784052040344",
      "meta_all"=> "ぼくのレオおじさん=> ルーマニア・アルノカ平原のぼうけん ヤネッツ レヴィ、たかい よしかず、Yannets Levi、 もたい なつう (2014/10/21)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ゆでたまごひめとみーとどろぼーる",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%82%86%E3%81%A7%E3%81%9F%E3%81%BE%E3%81%94%E3%81%B2%E3%82%81%E3%81%A8%E3%81%BF%E3%83%BC%E3%81%A8%E3%81%A9%E3%82%8D%E3%81%BC%E3%83%BC%E3%82%8B-%E8%8B%85%E7%94%B0-%E6%BE%84%E5%AD%90/dp/4774613851/ref=sr_1_1?s=books&ie=UTF8&qid=1414478520&sr=1-1&keywords=9784774613857",
      "meta_all"=> "ゆでたまごひめとみーとどろぼーる 苅田 澄子、 山村 浩二 (2014/10/24)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "しんかんせん で ビューン",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%97%E3%82%93%E3%81%8B%E3%82%93%E3%81%9B%E3%82%93-%E3%81%A7-%E3%83%93%E3%83%A5%E3%83%BC%E3%83%B3-%E8%A6%96%E8%A6%9A%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E7%A0%94%E7%A9%B6%E6%89%80/dp/4881082450/ref=sr_1_1?s=books&ie=UTF8&qid=1414478521&sr=1-1&keywords=9784881082454",
      "meta_all"=> "しんかんせん で ビューン 視覚デザイン研究所、 くにすえたくし (2014/10/25)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ひろみちおにいさんのげんきいっぱいだいさくせん! (サンチャイルド・ビッグサイエンス)",
      "book_page_url/_title"=> "ひろみちおにいさんのげんきいっぱいだいさくせん! (サンチャイルド・ビッグサイエンス)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%B2%E3%82%8D%E3%81%BF%E3%81%A1%E3%81%8A%E3%81%AB%E3%81%84%E3%81%95%E3%82%93%E3%81%AE%E3%81%92%E3%82%93%E3%81%8D%E3%81%84%E3%81%A3%E3%81%B1%E3%81%84%E3%81%A0%E3%81%84%E3%81%95%E3%81%8F%E3%81%9B%E3%82%93-%E3%82%B5%E3%83%B3%E3%83%81%E3%83%A3%E3%82%A4%E3%83%AB%E3%83%89%E3%83%BB%E3%83%93%E3%83%83%E3%82%B0%E3%82%B5%E3%82%A4%E3%82%A8%E3%83%B3%E3%82%B9-%E3%81%99%E3%81%8C%E3%82%8F%E3%82%89%E3%81%91%E3%81%84%E3%81%93/dp/4805440155/ref=sr_1_1?s=books&ie=UTF8&qid=1414478522&sr=1-1&keywords=9784805440155",
      "meta_all"=> [
        "ひろみちおにいさんのげんきいっぱいだいさくせん! (サンチャイルド・ビッグサイエンス)2014/10 すがわらけいこ、 佐藤弘道",
        "現在お取り扱いできません"
      ]
    }
  ],
  [
    {
      "book_page_url/_text"=> "つなひきばけくらべ (チャイルドブックアップル)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%A4%E3%81%AA%E3%81%B2%E3%81%8D%E3%81%B0%E3%81%91%E3%81%8F%E3%82%89%E3%81%B9-%E3%83%81%E3%83%A3%E3%82%A4%E3%83%AB%E3%83%89%E3%83%96%E3%83%83%E3%82%AF%E3%82%A2%E3%83%83%E3%83%97%E3%83%AB-%E4%B8%AD%E9%87%8E%E5%BC%98%E9%9A%86/dp/4805440511/ref=sr_1_1?s=books&ie=UTF8&qid=1414478523&sr=1-1&keywords=9784805440513",
      "meta_all"=> "つなひきばけくらべ (チャイルドブックアップル) 中野弘隆 (2014/10)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ぼうけん7のたん 冒険7の譚",
      "book_page_url/_title"=> "ぼうけん7のたん 冒険7の譚",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%BC%E3%81%86%E3%81%91%E3%82%937%E3%81%AE%E3%81%9F%E3%82%93-%E5%86%92%E9%99%BA7%E3%81%AE%E8%AD%9A-%E3%81%95%E3%81%84%E3%81%A8%E3%81%86%E3%82%88%E3%81%97%E3%81%B2%E3%81%95/dp/4568430895/ref=sr_1_1?s=books&ie=UTF8&qid=1414478524&sr=1-1&keywords=9784568430899",
      "meta_all"=> "ぼうけん7のたん 冒険7の譚2014/9/12 さいとうよしひさ"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ゆきんこクリスマス",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%82%86%E3%81%8D%E3%82%93%E3%81%93%E3%82%AF%E3%83%AA%E3%82%B9%E3%83%9E%E3%82%B9-%E3%81%9B%E3%81%8D%E3%82%84-%E3%82%88%E3%81%97%E3%81%8D/dp/4886265693/ref=sr_1_1?s=books&ie=UTF8&qid=1414478525&sr=1-1&keywords=9784886265692",
      "meta_all"=> "ゆきんこクリスマス せきや よしき、ラウラ リーゴ、Laura Rigo、 Roberta Pagnoni (2014/10)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ディズニー クリスマスコレクション",
      "book_page_url/_title"=> "ディズニー クリスマスコレクション",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%83%87%E3%82%A3%E3%82%BA%E3%83%8B%E3%83%BC-%E3%82%AF%E3%83%AA%E3%82%B9%E3%83%9E%E3%82%B9%E3%82%B3%E3%83%AC%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3-%E6%B0%B8%E5%B2%A1%E6%9B%B8%E5%BA%97%E7%B7%A8%E9%9B%86%E9%83%A8/dp/4522432968/ref=sr_1_1?s=books&ie=UTF8&qid=1414478526&sr=1-1&keywords=9784522432969",
      "meta_all"=> "ディズニー クリスマスコレクション2014/10/30 永岡書店編集部"
    }
  ],
  [
    {
      "book_page_url/_text"=> "地球が大変だ! ぼくと風さんの“温暖化\"を学ぶ旅",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E5%9C%B0%E7%90%83%E3%81%8C%E5%A4%A7%E5%A4%89%E3%81%A0-%E3%81%BC%E3%81%8F%E3%81%A8%E9%A2%A8%E3%81%95%E3%82%93%E3%81%AE%E2%80%9C%E6%B8%A9%E6%9A%96%E5%8C%96-%E3%82%92%E5%AD%A6%E3%81%B6%E6%97%85-%E6%9C%AA%E6%9D%A5-%E6%81%B5/dp/4286155218/ref=sr_1_1?s=books&ie=UTF8&qid=1414478527&sr=1-1&keywords=9784286155210",
      "meta_all"=> "地球が大変だ! ぼくと風さんの“温暖化\"を学ぶ旅 未来 恵 (2014/10/1)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "トミカ大集合 2015",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%83%88%E3%83%9F%E3%82%AB%E5%A4%A7%E9%9B%86%E5%90%88-2015-%E3%82%BF%E3%82%AB%E3%83%A9%E3%83%88%E3%83%9F%E3%83%BC/dp/4522433107/ref=sr_1_1?s=books&ie=UTF8&qid=1414478528&sr=1-1&keywords=9784522433102",
      "meta_all"=> "トミカ大集合 2015 タカラトミー (2014/10/20)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "プラレール大集合 2015",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%83%97%E3%83%A9%E3%83%AC%E3%83%BC%E3%83%AB%E5%A4%A7%E9%9B%86%E5%90%88-2015-%E3%82%BF%E3%82%AB%E3%83%A9%E3%83%88%E3%83%9F%E3%83%BC/dp/4522433115/ref=sr_1_1?s=books&ie=UTF8&qid=1414478528&sr=1-1&keywords=9784522433119",
      "meta_all"=> "プラレール大集合 2015 タカラトミー (2014/10/20)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "どうぶつたちのあきのごちそう (サンチャイルド・ビッグサイエンス)",
      "book_page_url/_title"=> "どうぶつたちのあきのごちそう (サンチャイルド・ビッグサイエンス)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%A9%E3%81%86%E3%81%B6%E3%81%A4%E3%81%9F%E3%81%A1%E3%81%AE%E3%81%82%E3%81%8D%E3%81%AE%E3%81%94%E3%81%A1%E3%81%9D%E3%81%86-%E3%82%B5%E3%83%B3%E3%83%81%E3%83%A3%E3%82%A4%E3%83%AB%E3%83%89%E3%83%BB%E3%83%93%E3%83%83%E3%82%B0%E3%82%B5%E3%82%A4%E3%82%A8%E3%83%B3%E3%82%B9-%E4%BB%8A%E6%B3%89%E5%BF%A0%E6%98%8E/dp/4805440163/ref=sr_1_1?s=books&ie=UTF8&qid=1414478529&sr=1-1&keywords=9784805440162",
      "meta_all"=> "どうぶつたちのあきのごちそう (サンチャイルド・ビッグサイエンス)2014/11 今泉忠明、 大久保茂徳"
    }
  ],
  [

  ],
  [
    {
      "book_page_url/_text"=> "10分で読める 憧れのあの人のサクセスストーリー",
      "book_page_url"=> "http=>//www.amazon.co.jp/10%E5%88%86%E3%81%A7%E8%AA%AD%E3%82%81%E3%82%8B-%E6%86%A7%E3%82%8C%E3%81%AE%E3%81%82%E3%81%AE%E4%BA%BA%E3%81%AE%E3%82%B5%E3%82%AF%E3%82%BB%E3%82%B9%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AA%E3%83%BC-%E3%82%B5%E3%82%AF%E3%82%BB%E3%82%B9%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AA%E3%83%BC%E7%A0%94%E7%A9%B6%E4%BC%9A/dp/4800233305/ref=sr_1_1?s=books&ie=UTF8&qid=1414478531&sr=1-1&keywords=9784800233301",
      "meta_all"=> "10分で読める 憧れのあの人のサクセスストーリー サクセスストーリー研究会 (2014/10/22)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "女の子のなぞなぞ1・2年生 660問!",
      "book_page_url/_title"=> "女の子のなぞなぞ1・2年生 660問!",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E5%A5%B3%E3%81%AE%E5%AD%90%E3%81%AE%E3%81%AA%E3%81%9E%E3%81%AA%E3%81%9E1%E3%83%BB2%E5%B9%B4%E7%94%9F-660%E5%95%8F-%E3%83%AA%E3%83%9C%E3%83%B3%E2%98%85%E3%83%8F%E3%82%A6%E3%82%B9/dp/4791621956/ref=sr_1_1?s=books&ie=UTF8&qid=1414478532&sr=1-1&keywords=9784791621958",
      "meta_all"=> "女の子のなぞなぞ1・2年生 660問!2014/10/11 リボン★ハウス"
    }
  ],
  [
    {
      "book_page_url/_text"=> "クヌギくんのぼうし",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%82%AF%E3%83%8C%E3%82%AE%E3%81%8F%E3%82%93%E3%81%AE%E3%81%BC%E3%81%86%E3%81%97-%E5%8F%A4%E6%B2%A2-%E3%81%9F%E3%81%A4%E3%81%8A/dp/4892193887/ref=sr_1_1?s=books&ie=UTF8&qid=1414478533&sr=1-1&keywords=9784892193880",
      "meta_all"=> "クヌギくんのぼうし 古沢 たつお (2014/10)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "ぼくはきみで きみはぼく",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%81%BC%E3%81%8F%E3%81%AF%E3%81%8D%E3%81%BF%E3%81%A7-%E3%81%8D%E3%81%BF%E3%81%AF%E3%81%BC%E3%81%8F-%E3%83%AB%E3%83%BC%E3%82%B9%E3%83%BB%E3%82%AF%E3%83%A9%E3%82%A6%E3%82%B9/dp/4033482903/ref=sr_1_1?s=books&ie=UTF8&qid=1414478534&sr=1-1&keywords=9784033482903",
      "meta_all"=> "ぼくはきみで きみはぼく ルース・クラウス、モーリス・センダック、 江國 香織 (2014/10/22)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "もののなまえ (はっけんずかんプチ)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%82%82%E3%81%AE%E3%81%AE%E3%81%AA%E3%81%BE%E3%81%88-%E3%81%AF%E3%81%A3%E3%81%91%E3%82%93%E3%81%9A%E3%81%8B%E3%82%93%E3%83%97%E3%83%81-%E6%A8%AA%E5%B1%B1-%E6%B4%8B%E5%AD%90/dp/4052039912/ref=sr_1_1?s=books&ie=UTF8&qid=1414478535&sr=1-1&keywords=9784052039911",
      "meta_all"=> "もののなまえ (はっけんずかんプチ) 横山 洋子、こふじた はなえ、 かろくこうぼう (2014/10/14)"
    }
  ],
  [
    {
      "book_page_url/_text"=> "やさいとくだもの (はっけんずかんプチ)",
      "book_page_url"=> "http=>//www.amazon.co.jp/%E3%82%84%E3%81%95%E3%81%84%E3%81%A8%E3%81%8F%E3%81%A0%E3%82%82%E3%81%AE-%E3%81%AF%E3%81%A3%E3%81%91%E3%82%93%E3%81%9A%E3%81%8B%E3%82%93%E3%83%97%E3%83%81-%E5%A5%A5%E5%B6%8B-%E4%BD%90%E5%92%8C%E5%AD%90/dp/4052039920/ref=sr_1_1?s=books&ie=UTF8&qid=1414478536&sr=1-1&keywords=9784052039928",
      "meta_all"=> "やさいとくだもの (はっけんずかんプチ) 奥嶋 佐和子、 ふじい かずえ (2014/10/14)"
    }
  ]
]


puts data_rows_3.class
puts data_rows_3.size

#puts data_rows_3.inspect
i = 0
until i == data_rows_3.size - 1
  if data_rows_3[i].empty?
    puts "Empty!"
  else
    puts data_rows_3[i][0]["book_page_url/_text"] 
  end
  i += 1
end

