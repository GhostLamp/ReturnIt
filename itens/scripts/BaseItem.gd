extends Resource
class_name BaseItem
# esse é o item base, todos os outros item devem herdar desse
# ele tem todas funções que os item vão precisar mas não precisa alterar todas em todos os itens da pra deixar vazia

# pra criar um item novo vc faz um script que com um "extends BaseItem" no inicio escreve o codigo do o item 
# nas funções que ele vai precisar, coloca um class_name (NomeDoItem) no topo, 
# dps vá em resource na pasta de itens e crie um novo resource, pesquise o nome que vc colocou na classe do item
# e deve aparecer lá, só clicar colocar um nome e seu item tá feito
# se vc clicar nele no inspector vai aparecer Name e Color, se quiser colocar coloque, mas n quebra nada se deixa o base

# o nome e a cor do item
@export var name:String = "vazio"
@export var color:Color 

# é a variavel que segura o display no inventario desse item
var display:ItemDisplay

# quando o jogador aperta espaço essa vai rodar
func on_jump(_player:Player) -> bool:
	return false

# quando o jogador tiver no chao essa vai rodar
func on_floor(_player:Player):
	pass

# quando o jogador tiver só encostando em uma parede essa vai rodar
func on_wall(_player:Player):
	pass

# quando empurra uma caixa
func on_push(_player:Player) -> int:
	return 0
