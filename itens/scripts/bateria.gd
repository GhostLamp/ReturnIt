extends BaseItem
class_name Bateria

@export var effect:PackedScene
var current = null

func on_add(player:Player):
	var eletric = effect.instantiate()
	player.anim_maneger.call_deferred("add_child",eletric)
	current = eletric

func on_remove(player:Player):
	if current:
		player.anim_maneger.remove_child(current)
		current = null
