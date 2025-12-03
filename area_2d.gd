extends Area2D
class_name EnergyArea

@onready var charger_collision: CollisionShape2D = $ChargerCollision


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is EletricMap:
		var tiles:EletricMap = body
		var coords = tiles.get_coords_for_body_rid(body_rid)
		tiles.powerCell(coords)
	
	if body is EletricDoor:
		body.power()


func _on_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is EletricMap:
		var colliders = get_overlapping_bodies()
		
		for i in colliders:
			if i is EletricMap:
				continue
			colliders.erase(i)
		
		if colliders.size() == 0:
			var tiles:EletricMap = body
			var coords = tiles.get_coords_for_body_rid(body_rid)
			tiles.unpowerCell(coords)
	
	if body is EletricDoor:
		body.unpower()
