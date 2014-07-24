require "nokogiri"
require "open-uri"

XPATH_INSCRICAO = "//tr[position() > 1]/td[2]/p/span/text()"

print "Informe o número da Matéria: "
@materia_id = gets
print "Informe o número da Edicação: "
@edicao_id = gets

BASE_IOMAT_URL = "http://www.iomat.mt.gov.br/do/navegadorhtml"
BASE_IOMAT_ATO_URL = "#{BASE_IOMAT_URL}/mostrar.htm?id=#{@materia_id}&edi_id=#{@edicao_id}"

page = Nokogiri::HTML(open(BASE_IOMAT_ATO_PAGE))

for node in page.xpath(XPATH_INSCRICAO)
	puts node.to_s
end
