extends TileMapLayer
class_name EletricMap

var powerCellAtlas:Vector2 = Vector2(3,4)
var unpowerCellAtlas:Vector2 = Vector2(10,4)

func powerCell(coord:Vector2):
	# coloca um tile carregado na cordenada e usa power map
	set_cell(coord,0,powerCellAtlas)
	powerMap()

func unpowerCell(coord:Vector2):
	# coloca um tile descarregado na cordenada e usa unpowermap
	set_cell(coord,0,unpowerCellAtlas)
	unpowerMap()

func powerMap():
	# pega todos tiles carregados e descarregados
	var unpowered_cells = get_used_cells_by_id(0,unpowerCellAtlas)
	var powered_cells = get_used_cells_by_id(0,powerCellAtlas)
	
	# em todo tile carregado vai olhar os tiles ao redor,
	# se um tile a redor for descarregado coloca um tile carregado no lugar e o coloca no ppowered_cells
	for i in powered_cells:
		for j in get_surrounding_cells(i):
			if unpowered_cells.has(j):
				set_cell(j,0,powerCellAtlas)
				powered_cells.append(j)
				unpowered_cells.erase(j)

func unpowerMap():
	# pega todos tiles carregados e descarregados
	var powered_cells = get_used_cells_by_id(0,powerCellAtlas)
	var unpowered_cells = get_used_cells_by_id(0,unpowerCellAtlas)
	
	# em todo tile descarregado vai olhar os tiles ao redor,
	# se um tile a redor for carregado coloca um tile descarregado no lugar e o coloca no ppowered_cells
	for i in unpowered_cells:
		for j in get_surrounding_cells(i):
			if powered_cells.has(j):
				set_cell(j,0,unpowerCellAtlas)
				unpowered_cells.append(j)
				powered_cells.erase(j)
