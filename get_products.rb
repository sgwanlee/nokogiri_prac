require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = Hash.new('http://www.possess.kr')
# Dress product image (first page)
# Example img url = http://www.possess.kr/shopimages/flfl0114/0020000002403.jpg
url['Dress'] = 'http://www.possess.kr/shop/shopbrand.html?xcode=002&type=O'
doc = Nokogiri::HTML(open(url['Dress']))


products = []
puts doc.at_css(".pbox")

doc.css(".pbox").each do |product|

	img_src = product.at_css('.prdimg img')['src']
	img_url = url['img'] + img_src
	price = product.css('.prdPrice').text
	price = price.gsub(/.*→/, '')
	img_name = img_src.gsub(/\//, '_')
	products << {img: img_url, price: price}
	open(img_name, 'wb') do |file|
		file << open(img_url).read
	end
end

open("product.txt", 'w') do |file|
	products.each do |product|
		file << product
	end
end






