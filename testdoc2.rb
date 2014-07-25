require "nokogiri"
require "open-uri"

f = File.open("doc/materia677634.html")
#page = Nokogiri::HTML(open("http://www.iomat.mt.gov.br/do/navegadorhtml/mostrar.htm?id=677634&edi_id=3732"))
page = Nokogiri::HTML(f)

data = page.xpath("//table[@class='topo_materia']//tr[3]/td[2]/text()").to_s[/(\d{2}\/\d{2}\/\d{4})/]
puts "Data: #{data}"

elementos = page.xpath("//tr[position() > 1]/td[2]/p/span/text()")
for node in elementos[1..10]
	puts node.to_s
end
