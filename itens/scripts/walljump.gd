extends BaseItem
class_name WallJump

# tempo que o jogador consegue se segurar na parede
var heldTime = 4

func on_jump(player:Player) -> bool:
	# só deixa pular da parede se tiver em contato só com a parede e esteja andando pra parede
	if player.is_on_wall_only() and player.velocity.x != 0:
		player.velocity.y = -600
		# inverte a velocidade para que o personage pule pra longe da parede
		player.velocity.x = -player.direction.x*player.speed/1.5
		
		heldTime -= 0.5
		
		return true
	return false

func on_wall(player:Player):
	# so prende o jogador na parede se ele estiver caindo andando pra parede, e se tá andando pra parede
	# essa função só roda qnd o jogador tá em contato só com a parede ent não tenho que checar isso aqui
	
	if player.velocity.y > 0 and heldTime > 1 and player.velocity.x != 0:
		# nos ultiimos 2 segundos a velocidade do y vai ser a gravidade dividida pelo o tempo que vc ainda tem segurando
		player.velocity.y /= heldTime
		
		if heldTime > 2:
			# nos primeiros 2 segundos a velocidade no y do jogador é a direção que tá apertando
			player.velocity.y = player.direction.y * 400
			
			# o tempo que vc pode ficar na parede cai mais rapido se vc ficar subindo ou descendo
			heldTime -= player.time/2 + (player.time * abs(player.direction.y))

# quando toca no chão vc ganho o tempo dnv
func on_floor(_player:Player):
	heldTime = 4
