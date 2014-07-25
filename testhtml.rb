require "nokogiri"
require "open-uri"

BASE_IOMAT_URL = "http://www.iomat.mt.gov.br/do/navegadorhtml"
link = "mostrar.htm?id=677634&edi_id=3732"

FILE_NAME = "testhtml.log"
file = File.open(FILE_NAME, "w")

URL = "#{BASE_IOMAT_URL}/#{link}"
puts "Acessando " + URL
page = Nokogiri::HTML(open(URL))
				
# testa se ato se refere ao Edital 004/2009-SAD/MT
if page.css("div#pagina p span").text =~ /Edital n\. 004\/2009-SAD\/MT/
	data = page.xpath("//table[@class='topo_materia']//tr[3]/td[2]/text()").to_s[/(\d{2}\/\d{2}\/\d{4})/]

	# retorna todos as inscrições
	elementos = page.xpath("//tr[position() > 1]/td[2]/p/span/text()")

	puts "Processando ato de #{data} com #{elementos.size} ocorrências."
	for node in elementos
		file.write("#{node};#{data}\n")
	end # inscricoes
	
end # if pagina contem "Edital 004/2009..."

puts "Finalizando arquivo " + FILE_NAME
file.close unless file == nil
