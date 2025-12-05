extends CharacterBody2D
class_name EletricDoor

@onready var timer: Timer = $Timer
@onready var area_2d: Area2D = $Area2D
@onready var area_colision: CollisionShape2D = $Area2D/areaColision

@onready var eletric_checker: Area2D = $eletric_checker
@onready var eletric_colision: CollisionShape2D = $eletric_checker/eletricColision

@onready var color_rect: ColorRect = $ColorRect

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var charger_collision: CollisionShape2D = $Charger/ChargerCollision

# se a porta deve se fechar ou abrir quando recebe energia
@export var close_on_power:bool = false

var time_to_refresh:float = 0.1

var powered = false

var tween:Tween

var color_size_open = Vector2(48,16)
var color_size_close = Vector2(48,128)

var area_size_open = Vector2(64,16)
var area_size_close = Vector2(64,128)
var area_position_open = Vector2(0,-96)
var area_position_close = Vector2(0,-40)

var collision_size_open = Vector2(48,16)
var collision_size_close = Vector2(48,128)

var collison_position_open = Vector2(0,-88)
var collison_position_close = Vector2(0,-32)

var charge_position_open = Vector2(0,-80)
var charge_position_close = Vector2(0,32)

func _ready() -> void:
	# o tempo em que a função vai rodar o salveguarda
	timer.wait_time = time_to_refresh
	# quando a cena começa
	color_rect.color = Color.WHITE
	charger_collision.disabled = true
	
	# coloca os valores das areas da porta pros seus valor inicia dependedo se tiver aberta ou não
	if close_on_power:
		color_rect.size = color_size_open
	
		area_colision.shape.size = area_size_open
		area_colision.position = area_position_open
		
		eletric_colision.shape.size = area_size_open
		eletric_colision.position = area_position_open
		
		collision_shape_2d.shape.size = collision_size_open
		collision_shape_2d.position = collison_position_open
		
		charger_collision.position = charge_position_open
	
	else:
		color_rect.size = color_size_close
	
		area_colision.shape.size = area_size_close
		area_colision.position = area_position_close
		
		eletric_colision.shape.size = area_size_close
		eletric_colision.position = area_position_close
		
		collision_shape_2d.shape.size = collision_size_close
		collision_shape_2d.position = collison_position_close
		
		charger_collision.position = charge_position_close


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is EletricMap:
		# se o corpo for um EleticMap
		
		# ve se o tile que saiu ainda existe, se não descarrega a porta e retorna
		if !body.has_body_rid(body_rid):
			unpower()
			return
		
		
		# pega a coordenada no atlas do tile
		var tiles:EletricMap = body
		var coords = tiles.get_coords_for_body_rid(body_rid)
		var atlasCoords = tiles.get_cell_atlas_coords(coords)
		
		# o tile carregado tem uma coordenada no atlas de 3,4
		# ent se for um tile carregado, carrega a porta se não for descarrega ela 
		if atlasCoords == Vector2i(3,4):
			power()
		
		else:
			unpower()


# essa função é mais um salve-gaurada pra impedir que ela fique presa enquanto tá ativa ou desativa dps de ser carregada e descarregada mt rapido
# o eletric checker.get_overlapping_areas/bodies vai vê se tem alguma coisa marcada como eletrica emcontato com a porta
# se não tiver nada e a porta tiver ativada, desativa ela
func refresh():
	if eletric_checker.get_overlapping_areas().size() == 0 and eletric_checker.get_overlapping_bodies().size() == 0 and powered:
		unpower()
		return
	if (eletric_checker.get_overlapping_areas().size() > 0 or eletric_checker.get_overlapping_bodies().size() > 0)  and !powered:
		power()
		return
	
	# vez que esse timer acaba essa função é rodada e recomeça o timer
	timer.start()


func power():
	# se já tiver um tween rolando para ele e cria um novo
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	
	# começa o tween ativando a area eletrica e dps vé se vai usar os tweens pra abrir do open ou close
	tween.tween_property(charger_collision,"disabled",false,0.125)
	tween.set_parallel().tween_property(color_rect,"color",Color.YELLOW,0.125)
	if close_on_power:
		close()
	else:
		open()
	tween.tween_property(self,"powered",true,0.125)
	
	# reinicia o timer do refresh
	timer.start()



func unpower():
	# primeiro checa se não tem mais nada carregando a porta
	# pegando todas os corpos dentro da eletric_checker
	# se for condutor ou um eletric map retorna a função
	for i in eletric_checker.get_overlapping_bodies():
		if i is EletricMap:
			return
		if i.is_in_group("conductors"):
			return
	
	# se já tiver um tween rolando para ele e cria um novo
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	
	# começa o tween desativando a area eletrica e dps vé se vai usar os tweens pra abrir do open ou close
	tween.tween_property(charger_collision,"disabled",true,0.125)
	tween.set_parallel().tween_property(color_rect,"color",Color.WHITE,0.125)
	if close_on_power:
		open()
	else:
		close()
	tween.tween_property(self,"powered",false,0.125)
	
	# reinicia o timer do refresh
	timer.start()


func close():
	# move as posições da porta pro estado de fechado em 0.125 segundos
	tween.set_parallel().tween_property(color_rect,"size",color_size_close,0.125)
	
	tween.set_parallel().tween_property(area_colision.shape,"size",area_size_close,0.125)
	tween.set_parallel().tween_property(area_colision,"position",area_position_close,0.125)
	
	tween.set_parallel().tween_property(eletric_colision.shape,"size",area_size_close,0.125)
	tween.set_parallel().tween_property(eletric_colision,"position",area_position_close,0.125)
	
	tween.set_parallel().tween_property(collision_shape_2d.shape,"size",collision_size_close,0.125)
	tween.set_parallel().tween_property(collision_shape_2d,"position",collison_position_close,0.125)
	
	tween.set_parallel().tween_property(charger_collision,"position",charge_position_close,0.125)

func open():
	# move as posições da porta pro estado de aberto em 0.125 segundos
	tween.set_parallel().tween_property(color_rect,"size",color_size_open,0.125)
	
	tween.set_parallel().tween_property(area_colision.shape,"size",area_size_open,0.125)
	tween.set_parallel().tween_property(area_colision,"position",area_position_open,0.125)
	
	tween.set_parallel().tween_property(eletric_colision.shape,"size",area_size_open,0.125)
	tween.set_parallel().tween_property(eletric_colision,"position",area_position_open,0.125)
	
	tween.set_parallel().tween_property(collision_shape_2d.shape,"size",collision_size_open,0.125)
	tween.set_parallel().tween_property(collision_shape_2d,"position",collison_position_open,0.125)
	
	tween.set_parallel().tween_property(charger_collision,"position",charge_position_open,0.125)
