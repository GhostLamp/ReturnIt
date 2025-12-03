extends TileMapLayer
class_name EletricMap

func powerCell(cell:Vector2):
	set_cell(cell,0,Vector2(3,4))
	powerMap()

func unpowerCell(cell:Vector2):
	set_cell(cell,0,Vector2(10,4))
	unpowerMap()

func powerMap():
	var unpowered_cells = get_used_cells_by_id(0,Vector2(10,4))
	var powered_cells = get_used_cells_by_id(0,Vector2(3,4))
	for i in powered_cells:
		for j in get_surrounding_cells(i):
			if unpowered_cells.has(j):
				set_cell(j,0,Vector2(3,4))
				powered_cells.append(j)
				unpowered_cells.erase(j)

func unpowerMap():
	var powered_cells = get_used_cells_by_id(0,Vector2(3,4))
	var unpowered_cells = get_used_cells_by_id(0,Vector2(10,4))
	for i in unpowered_cells:
		for j in get_surrounding_cells(i):
			if powered_cells.has(j):
				set_cell(j,0,Vector2(10,4))
				unpowered_cells.append(j)
				powered_cells.erase(j)
