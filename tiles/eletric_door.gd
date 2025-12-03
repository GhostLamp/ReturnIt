extends CharacterBody2D
class_name EletricDoor

@onready var area_2d: Area2D = $Area2D
@onready var eletric_checker: Area2D = $eletric_checker
@onready var eletric_colision: CollisionShape2D = $eletric_checker/eletricColision

@onready var area_colision: CollisionShape2D = $Area2D/areaColision
@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var charger_collision: CollisionShape2D = $eletric_area/ChargerCollision


@export var close_on_power:bool = false


var tween:Tween

var powered = false

func _ready() -> void:
	tween = get_tree().create_tween()
	
	tween.tween_property(color_rect,"color",Color.WHITE,0.125)
	tween.set_parallel().tween_property(charger_collision,"disabled",true,0.125)
	
	if close_on_power:
		open()
	else:
		close()

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is EletricMap:
		if !body.has_body_rid(body_rid):
			unpower()
			return
		
		var tiles:EletricMap = body
		var coords = tiles.get_coords_for_body_rid(body_rid)
		var atlasCoords = tiles.get_cell_atlas_coords(coords)
		
		if atlasCoords == Vector2i(3,4):
			power()
			return
		
		elif atlasCoords == Vector2i(10,4):
			unpower()

func power():
	powered = true
	if tween:
		tween.kill
	

	tween = get_tree().create_tween()
	
	tween.tween_property(color_rect,"color",Color.YELLOW,0.125)
	tween.set_parallel().tween_property(charger_collision,"disabled",false,0.125)
	if close_on_power:
		close()
	else:
		open()

func unpower():
	
	for i in eletric_checker.get_overlapping_bodies():
		if i is EletricMap:
			return
		if i.is_in_group("conductors"):
			return
	
	powered = false
	if tween:
		tween.kill
	

	tween = get_tree().create_tween()
	
	tween.tween_property(color_rect,"color",Color.WHITE,0.125)
	tween.set_parallel().tween_property(charger_collision,"disabled",true,0.125)
	
	if close_on_power:
		open()
	else:
		close()

func open():
	tween.set_parallel().tween_property(color_rect,"size",Vector2(48,16),0.125)
	
	tween.set_parallel().tween_property(area_colision.shape,"size",Vector2(64,16),0.125)
	tween.set_parallel().tween_property(area_colision,"position",Vector2(0,-96),0.125)
	
	tween.set_parallel().tween_property(eletric_colision.shape,"size",Vector2(64,16),0.125)
	tween.set_parallel().tween_property(eletric_colision,"position",Vector2(0,-96),0.125)
	
	tween.set_parallel().tween_property(collision_shape_2d.shape,"size",Vector2(48,16),0.125)
	tween.set_parallel().tween_property(collision_shape_2d,"position",Vector2(0,-88),0.125)
	
	tween.set_parallel().tween_property(charger_collision,"position",Vector2(0,-80),0.125)


func close():
	tween.set_parallel().tween_property(color_rect,"size",Vector2(48,128),0.125)
	
	tween.set_parallel().tween_property(area_colision.shape,"size",Vector2(64,128),0.125)
	tween.set_parallel().tween_property(area_colision,"position",Vector2(0,-40),0.125)
	
	tween.set_parallel().tween_property(eletric_colision.shape,"size",Vector2(64,128),0.125)
	tween.set_parallel().tween_property(eletric_colision,"position",Vector2(0,-40),0.125)
	
	tween.set_parallel().tween_property(collision_shape_2d.shape,"size",Vector2(48,128),0.125)
	tween.set_parallel().tween_property(collision_shape_2d,"position",Vector2(0,-32),0.125)
	
	tween.set_parallel().tween_property(charger_collision,"position",Vector2(0,32),0.125)
