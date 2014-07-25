#encoding:UTF-8
require "nokogiri"
require "open-uri"

BASE_IOMAT_URL = "http://www.iomat.mt.gov.br/do/navegadorhtml"
EDICAO_INICIO = 3732 #3434
EDICAO_FIM = 3732

MENU_URL = "#{BASE_IOMAT_URL}/load_tree.php?edi_id="

REGEX_LISTA_ATOS = /gFld\("ATO DO GOVERNADOR"[\s\S]*?gFld\("NOMEA\S\SO;\n([\s\S]*?)c\d+ = gFld/m

FILE_NAME = "inscricoes.log"

file = File.open(FILE_NAME, "w")

# processa cada diário ofical 
# do dia 11/06/2013 a 27/06/2014
for edicao in EDICAO_INICIO..EDICAO_FIM

	# acessa página com o menu das matérias
	pagina_menu = Nokogiri::HTML(open(MENU_URL + edicao.to_s), nil, 'ISO-8859-1')
	
	# busca o nó 'script' contendo o menu
	pagina_menu.xpath('//script[not(@src)]').each do |node|
	
		# captura o bloco do texto dos atos de nomeação		
		m = REGEX_LISTA_ATOS.match(node.content)
		
		if m
			atos_block = m.captures
			# para cada ato acessar documento 
			atos_block[0].each_line do |line|
				ato, link = /\["(.+)".+"(.+)"\]/.match(line).captures
				url = "#{BASE_IOMAT_URL}/#{link}"
				
				puts "Acessando " + url
				page = Nokogiri::HTML(open(url), nil, 'ISO-8859-1')
				page.encoding = 'UTF-8'
				
				# testa se ato se refere ao Edital 004/2009-SAD/MT
				if page.css("div#pagina p span").text =~ /Edital n\. 004\/2009-SAD\/MT/
					data = page.xpath("//table[@class='topo_materia']//tr[3]/td[2]/text()").to_s[/(\d{2}\/\d{2}\/\d{4})/]

					# retorna todos as inscrições
					elementos = page.xpath("//tr[position() > 1]/td[2]/p/span/text()")
					
					puts "Processando ato de #{data} com #{elementos.size} ocorrências."
					
					for node in elementos
						file.write("#{node};#{ato};#{data}\n")
					end # inscricoes
					
				end # if pagina contem "Edital 004/2009..."
				
			end # each_line menu atos
			
		end # if tem atos de nomeação
		
	end # each 'script' que contem menu de atos
	
end

puts "Finalizando arquivo " + FILE_NAME
file.close unless file == nil

