extends CharacterBody2D
class_name Box

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var moving:bool = false
var tile_size:int = 64
var gravity = 1800

# se colocando ou tirando das areas de interação do jogador
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.erase(self)



func _physics_process(delta: float) -> void:
	# enquanto a caixa tá se movendo por coasua de um empurrão ela ignora a fisica
	if moving:
		velocity.y = 0
		return
	
	velocity.y += delta*gravity
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().get_parent() is Player:
			var directionToBox = collision.get_collider().global_position.direction_to(global_position)
			if abs(directionToBox.x) >= abs(directionToBox.y):
				directionToBox = Vector2(sign(directionToBox.x),0)
			else:
				directionToBox = Vector2(0,sign(directionToBox.y))
			
			if directionToBox == Vector2(0,1):
				global_position.x = collision.get_collider().global_position.x


func interact(player: Player):
	# só pode empurrar a caixa se ela não está se movendo, tá no chão e o jogador tá no chão
	if moving or !is_on_floor() or !player.is_on_floor():
		return
	
	# pegando a direção do jogador da caixa, e dps normalizando a direção pra que seja (1,0),(-1,0),(0,1),(0,-1)
	var directionToBox = player.global_position.direction_to(global_position)
	
	if abs(directionToBox.x) >= abs(directionToBox.y):
		directionToBox = Vector2(sign(directionToBox.x),0)
	else:
		directionToBox = Vector2(0,sign(directionToBox.y))
	
	# pra cada item no jogador adiciona a qauntidade de força extra de cada
	var plusForce = 0
	for i in player.items:
		plusForce += i.on_push(player)
	
	# checa até ond a caixa pode com a forca naquela direção
	checkPos(1 + plusForce,directionToBox)

func checkPos(force:int,direction:Vector2):
	# coloca a posição onde a caixa vai parar, e atualiza o raycast para a posição de onde a caixa vai parar
	var desired_position = global_position + tile_size *direction * force
	tile_size*floor((desired_position)/tile_size)
	ray_cast_2d.target_position = direction * tile_size * force * 1.5
	ray_cast_2d.force_raycast_update()
	
	# distancia que a caixa vai ter até o ponto de parada
	var distance:Vector2 = Vector2(0,0)
	
	# se o raycast colidir com alguma coisa, ajusta a posição de onde a caixa deve parar
	if ray_cast_2d.is_colliding():
		distance = Vector2i(ray_cast_2d.get_collision_point()/tile_size - global_position/tile_size)
		desired_position = tile_size*floor((global_position + Vector2(distance*tile_size))/tile_size) + Vector2(tile_size,tile_size)/2
	
	# roda a função para mover a caixa e envia a distancia e a posição final
	# eu uso o valor absoluto da distancia e divido por 4, aumentar ou diminuir o 4 vai aumentar ou diminuir o tempo que a caixa fica se mechendo
	moveToNewPos(abs(distance)/4, desired_position)


func moveToNewPos(dis:Vector2,desired_position):
	moving = true
	
	var tween = get_tree().create_tween()
	# faz um tween pra levar a caixa da posição atual até a posição final, e aumenta o tempo que isso vai levar dependendo da distançia
	tween.tween_property(self,"position",desired_position,(1+dis.x+dis.y)*0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"moving",false,0.01)
	# quando termina de movimentar a caixa até a posição final coloca moving de volta pra false
