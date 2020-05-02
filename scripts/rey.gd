extends "res://scripts/piece.gd"

func set_movable():
	movable = []
	
	for x in range(-1,2):
		for y in range(-1,2):
			var _pos = grid_pos + Vector2(x, y)
			if Board.inside_grid(_pos):
				if Board.at_grid(_pos) == null:
					movable.append(_pos)
				elif Board.at_grid(_pos).team != team:
					movable.append(_pos)
