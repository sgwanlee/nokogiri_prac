require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

url = Hash.new('http://www.possess.kr')
# Dress product image (first page)
# Example img url = http://www.possess.kr/shopimages/flfl0114/0020000002403.jpg
url['Dress'] = '/shop/shopbrand.html?xcode=002&type=O'
# doc = Nokogiri::HTML(open(url['Dress']))

agent = Mechanize.new
page = agent.get(url[:default])
page = agent.page.link_with(href: url['Dress']).click

pagination = agent.page.links_with(:href => /page=/)[0..-2]

products = []

pagination.each do |page|
	page = page.click

	page.search(".pbox").each do |product|
		# Get image & price info.
		img_src = product.at_css('.prdimg img')['src']
		img_url = url['img'] + img_src
		price = product.css('.prdPrice').text.gsub(/.*→/, '')

		products << {img: img_url, price: price}
		
		Save image
		open(img_src.gsub(/\//, '_'), 'wb') do |file|
			file << open(img_url).read
		end
	end

end 

# Save price info.
open("product.txt", 'w') do |file|
	file << products
end






