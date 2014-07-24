require "nokogiri"
require "open-uri"

BASE_IOMAT_URL = "http://www.iomat.mt.gov.br/do/navegadorhtml"
@edicao_final = 3732

MENU_URL = "#{BASE_IOMAT_URL}/load_tree.php?edi_id="

# processa cada diário ofical 
# do dia 11/06/2013 a 27/06/2014
for edicao in 3434..3732
	pagina_menu = Nokogiri::HTML(open(MENU_URL + edicao.to_s))
end

XPATH_INSCRICAO = "//tr[position() > 1]/td[2]/p/span/text()"

print "Informe o número da Matéria: "
@materia_id = gets.chomp
print "Informe o número da Edição: "
@edicao_id = gets.chomp


BASE_IOMAT_ATO_URL = "#{BASE_IOMAT_URL}/mostrar.htm?id=#{@materia_id}&edi_id=#{@edicao_id}"

page = Nokogiri::HTML(open(BASE_IOMAT_ATO_URL))
elementos = page.xpath(XPATH_INSCRICAO)

puts "Encontrado #{elementos.length} nomeados neste ato."
puts "Lista de inscrições:"

for node in elementos
	puts node.to_s
end
