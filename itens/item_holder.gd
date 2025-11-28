extends Area2D
class_name ItemHolder
# sinalzinho pra atualizar a porta quando coloca ou tira items
signal update_door

# onde o item fica "guardado"
@export var item:BaseItem

func _ready() -> void:
	# se tiver um item a caixa no meio usa a cor dele, se não fica preta
	if item:
		$ColorRect2.color = item.color
		return
	$ColorRect2.color = Color.BLACK

# se colocando ou tirando das areas de interação do jogador
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interaction_areas.erase(self)


func interact(player: Player):
	# quando interage com um pedestal ele checa se aqui tem um item
	# se tiver coloca uma copia dele nos items do jogador e apaga o item daqui
	if item:
		player.add_item(item)
		item = null
		$ColorRect2.color = Color.BLACK
	
	# se não cria uma copia do item aqui e apaga o do jogador
	elif player.items.size() > 0:
		item = player.items[0]
		player.remove_item(item)
		$ColorRect2.color = item.color
	
	emit_signal("update_door")
