extends Node2D
class_name World

@onready var player: Player = $player

# o nivel atual
@export var current_level:Level

@export_file("*.tscn") var last_path:String
@export_file("*.tscn") var level_path:String

var start_door:int = 0 
var last_player_items:Array

func _ready() -> void:
	connect_door_signal(current_level.doors)
	set_level()


func connect_door_signal(doors:Array[Door]):
	# conecta o sinal swap_level das portas no nivel pra função swap_level 
	for i in doors:
		i.connect("swap_level",swap_level)

func swap_level(new_level:String,new_start:int):
	# apaga o lugar atual
	start_door = new_start
	
	if current_level:
		current_level.queue_free()
	
	# salva o ultimo caminho
	last_path = level_path
	
	# salva o novo caminho
	level_path = new_level
	
	# cria o novo 
	var level = load(new_level).instantiate()
	call_deferred("add_child",level)
	current_level = level
	
	# conecta as portas e coloca os items que o jogador deve ter no começo da fase nele
	connect_door_signal(current_level.doors)
	set_level()

func set_level():
	for i in current_level.start_items:
		if player.items.size() < player.item_limit:
			player.add_item(i.duplicate(false))
	
	player.global_position = current_level.doors[start_door].global_position

func reset():
	for i in player.items.size():
		player.remove_item(player.items[0])
	swap_level(level_path,start_door)
