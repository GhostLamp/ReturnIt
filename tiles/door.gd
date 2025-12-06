extends Area2D
class_name Door

# o sinal pro world pra quando vai trocar de nivel
signal swap_level

# a string do file path da cena que essa porta leva
@export_file("*.tscn") var goes_to: String 
@export var goes_to_door:int = 0

# isso é todos os lugares em que coloca items que essa porta vai pecisar pra abrir
@export var needs:Array[ItemHolder]

@export var exit_door:bool = true

# o texto que fica em cima da porta
@export var nome:String = "saida"

var open:bool = false

@onready var animPlayer: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	$Label.text = nome
	# conecta o sinal update_door de todos os item holders necessarios pra função update_door
	# ai quando o jogador coloca ou tira uma coisa de um item holder o sinal vem pra cá e a porta pode checar se tem que tar aberta ou fechada
	for i in needs:
		i.connect("update_door",update_door)
	
	# atualiza a porta pra que ela fique no estado correto
	update_door()


func update_door():
	# isso checa se a porta deve se abrir
	for i in needs:
		if i.item:
			continue
		
		# se um item tiver faltando a porta é colocado como fechada retorna a função
		if open:
			animPlayer.play("close")
			open = false
		return
	
	# se todos os item holder tiverem seus items a função vai terminar o loop e acabar aqui 
	if !open:
		animPlayer.play("open")
		open = true

func interact(_player: Player):
	# quando o jogador interage com a porta,ve se tá fechada
	#, se não tiver mando o world trocar de nivel pro nivel no goes_to
	if !open:
		return
	
	
	emit_signal("swap_level",goes_to,goes_to_door)

# se colocando ou tirando das areas de interação do jogador
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.erase(self)
