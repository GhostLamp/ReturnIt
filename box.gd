extends CharacterBody2D
class_name Box

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var desired_position:Vector2
var moving:bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.erase(self)



func _physics_process(delta: float) -> void:
	if moving:
		velocity.y = 0
		return
	
	velocity.y += delta*1800
	move_and_slide()
	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider() is Player:
			if collision.get_collider().global_position.direction_to(global_position).round() == Vector2(0,1):
				global_position.x = collision.get_collider().global_position.x


func interact(player: Player):
	if moving or !is_on_floor() or !player.is_on_floor():
		return
	
	var directionToBox = player.global_position.direction_to(global_position)
	
	if abs(directionToBox.x) >= abs(directionToBox.y):
		directionToBox = Vector2(sign(directionToBox.x),0)
	else:
		directionToBox = Vector2(0,sign(directionToBox.y))
	
	var plusForce = 0
	for i in player.items:
		plusForce += i.on_push(player)
	checkPos(1 + plusForce,directionToBox)

func checkPos(force:int,direction:Vector2):
	desired_position = global_position + 64*direction
	ray_cast_2d.target_position = direction * 64 * force * 1.5
	ray_cast_2d.force_raycast_update()
	var distance:Vector2 = Vector2(0,0)
	if ray_cast_2d.is_colliding():
		distance = Vector2i(ray_cast_2d.get_collision_point()/64- global_position/64)
		desired_position = 64*floor((global_position + Vector2(distance*64))/64) + Vector2(32,32)
		print(desired_position)
	
	moveToNewPos(abs(distance)/4)


func moveToNewPos(dis:Vector2):
	moving = true
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"position",desired_position,(1+dis.x+dis.y)*0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"moving",false,0.01)
