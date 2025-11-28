extends Node2D
class_name World

@onready var player: Player = $player

# o nivel atual
@export var current_level:Level

func _ready() -> void:
	connect_door_signal(current_level.doors)
	set_level()

func connect_door_signal(doors:Array[Door]):
	# conecta o sinal swap_level das portas no nivel pra função swap_level 
	for i in doors:
		i.connect("swap_level",swap_level)

func swap_level(new_level:String):
	# apaga o lugar atual
	if current_level:
		current_level.queue_free()
	
	# cria o novo 
	var level = load(new_level).instantiate()
	call_deferred("add_child",level)
	current_level = level
	
	# conecta as portas e coloca os items que o jogador deve ter no começo da fase nele
	connect_door_signal(current_level.doors)
	set_level()

func set_level():
	for i in current_level.start_items:
		player.add_item(i)
