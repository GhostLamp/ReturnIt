extends Area2D
class_name EnergyArea



func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is EletricMap:
		# quando um EletricMap entra na area pega as cordenadas do tile que tá dentro, 
		# e manda o tileset usa power cell na coordenada pra "eletrizar" ela
		var tiles:EletricMap = body
		var coords = tiles.get_coords_for_body_rid(body_rid)
		tiles.powerCell(coords)
	
	
	if body is EletricDoor:
		# se for uma EletricDoor que entrou, só usa a função power dela
		body.power()


func _on_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is EletricMap:
		# se o tile não existir mais para a função
		if !body.has_body_rid(body_rid):
			return
		
		# quando um EletricMap sai, primeiro coloca todos objetos que tão dentro da area no colliders
		var colliders = get_overlapping_bodies()
		
		# retira todos os objetos que não são EletricMap do colliders
		for i in colliders:
			if i is EletricMap:
				continue
			colliders.erase(i)
		
		# se não sobrar nada significa que o jogador saiu de contatocom o tilemap, e pode pegar a cordenada do tile que saiu e manda o tile map descarregar
		# se não, significa que o saiu de contato de um tile pro outro, e não é pra descarregar ainda
		if colliders.size() == 0:
			var tiles:EletricMap = body
			var coords = tiles.get_coords_for_body_rid(body_rid)
			tiles.unpowerCell(coords)
	
	if body is EletricDoor:
		# se for uma EletricDoor que saiu, só usa a função unpower dela
		body.unpower()
