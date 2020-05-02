extends "res://scripts/piece.gd"

func set_movable():
	var dirs = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	for i in dirs:
		var _pos = grid_pos + i * 2
		for y in range(0,2):
			y = y*2 - 1
			var new_pos = _pos + Vector2(i.y * y, i.x * y)
			
			if Board.inside_grid(new_pos):
				if Board.at_grid(new_pos) == null:
					movable.append(new_pos)
				else:
					if Board.at_grid(new_pos).team != team:
						movable.append(new_pos)
