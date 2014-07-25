
require "nokogiri"
require "open-uri"

FILENAME = "doc/ed3732_menu.html"
f = File.open(FILENAME)

URL = "http://www.iomat.mt.gov.br/do/navegadorhtml/load_tree.php?edi_id=3732"

REGEX = /gFld\("ATO DO GOVERNADOR"[\s\S]*?gFld\("NOMEAÇÃO".+?;\n([\s\S]*?)c\d+ = gFld/m

#doc = Nokogiri::XML(f)
doc = Nokogiri::HTML(open(URL).read, nil, 'utf-8')

doc.xpath('//script[not(@src)]').each do |node|
	atos_block = REGEX.match(node.content).captures
	if atos_block
		atos_block[0].each_line do |line|
			array = /\["(.+)".+"(.+)"\]/.match(line).captures.to_a
			puts array[1]
		end
	end
end
