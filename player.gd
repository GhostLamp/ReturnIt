extends CharacterBody2D
class_name Player

# o invetario de items que aparece na topo da direita
@onready var invetory: VBoxContainer = $CanvasLayer/invetory

# a textura atras do inventario
@onready var inventory_background: ColorRect = $CanvasLayer/inventoryBackground

#o array pra guardar todos os items
@export var items:Array[BaseItem]

var item_limit:int = 5

# é criado pra mostrar a cor e o nome dos items que vc tem no iventario
@export var itemDisplay:PackedScene

@export var speed:float = 400
@export var accel:float = 4000


# eu uso esse array pra guardar todas as coisas que o jogador pode interagir no momento
# a door e o item holder se colocam aqui quando o jogador entra na area e se tiram quando ele sai
var interaction_areas:Array[Node2D]

var direction = Vector2(0,0)
var gravity = 1800
var time:float = 0

func _process(delta: float) -> void:
	# guardando o delta time atual pra usar nos itens
	time = delta
	movement(delta)
	
	# usando uma função pra organizar as coisas que vc vai interagir pra que a mais proxima seja a primeira
	if interaction_areas.size() > 0:
		interaction_areas.sort_custom(sort_interection_areas)
	
	# quando vc aperta f usa a função de interagir na primeira area 
	# e manda o proprio o proprio jogador como argumento pra poder tirar e retirar items dele
	if Input.is_action_just_pressed("i"):
		if interaction_areas.size() > 0:
			interaction_areas[0].interact(self)


# sisteminha de movimentação basico
func movement(delta: float):
	direction = Input.get_vector("left", "right", "up", "down")
	
	
	if is_on_floor():
		# enquanto tá no chão roda a on_floor em todos itens
		# eu sei que o for que passa por todos items parece ser devegar 
		# mas não afeta a performace na quantidade de itens que eu espero que vai usar
		# e da pra fazer mais rapido com sinais se precisar
		for i in  items:
			i.on_floor(self)
		
		# só movendo a velocidade até a direação com o speed usando uma aceleração 
		# e igualo y a 0 pra não carregar a velocidade dps do ultimo pulo
		velocity.x = move_toward(velocity.x, direction.x * speed, accel*delta)
		velocity.y = 0
	
	else:
		# mesma coisa da função passada mas com uma aceleração pior pra que o controle no ar seja mais lento 
		velocity.x = move_toward(velocity.x,direction.x * speed,accel*delta/2)
		
		# isso aqui para a subida do pulo quando vc solta espaço
		if Input.is_action_just_released("ui_accept"):
			velocity.y = max(0,velocity.y)
		
		# é uma gravidade que fica mais forte quando vc tá caindo, pro personagem não ficar mt flutuante
		velocity.y += (gravity + (1 + sign(velocity.y))*gravity/2) * delta
	
	
	# a parte que controla o pulo
	if Input.is_action_just_pressed("ui_accept"):
		# roda a função on_jump em todos items
		for i in  items:
			i.on_jump(self)
		
		#só te joga pra cima se tiver no çhão
		if is_on_floor():
			velocity.y = -800
	
	# mesma checagem dos itens só que pra quando o jogador tá só encostando na parede
	if is_on_wall_only():
		for i in  items:
			i.on_wall(self)
	
	move_and_slide()


func add_item(item:BaseItem):
	# adiciona o item nos items do jogador, e cria um display no invetario
	items.append(item)
	var new_display:ItemDisplay = itemDisplay.instantiate()
	new_display.displayText  = item.name
	new_display.displayColor = item.color
	invetory.call_deferred("add_child",new_display)
	
	# uma referencia do display no item
	item.display = new_display


func remove_item(item:BaseItem):
	# tira o item nos items do jogador, e apago o display no invetario do item
	items.erase(item)
	if item.display:
		item.display.queue_free()

# a função que organiza as areas de interação
func sort_interection_areas(area1, area2):
	var area1_to_player = self.global_position.distance_to(area1.global_position)
	var area2_to_player = self.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
