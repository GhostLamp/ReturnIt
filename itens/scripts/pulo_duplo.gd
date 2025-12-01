extends BaseItem
class_name PuloDuplo

var jumps = 1

# quando o jogador pula, se não estiver no chão e tiver pulos, aumenta a velocidade no y e diminui a quantidade de pulos
func on_jump(player:Player) -> bool:
	if not player.is_on_floor() and jumps > 0:
		player.velocity.y = -800
		jumps -= 1
	
	return true

# quando o jogador pisa no chão coloca a quantidade de pulos de volta a 1
func on_floor(_player:Player):
	jumps = 1
