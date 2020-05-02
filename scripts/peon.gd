extends "res://scripts/piece.gd"

func set_movable():
	if Board.at_grid(Vector2(grid_pos.x, grid_pos.y+team)) == null:
		movable = [Vector2(grid_pos.x, grid_pos.y+team)]
		
	for i in range(0,2):
		var _p = grid_pos + Vector2(i*2-1, team)
		var cell = Board.at_grid(_p)
		if cell != null:
			if cell.team != team:
				movable.append(_p)
	
	if (team == -1 and grid_pos.y == 6) or (grid_pos.y == 1 and team == 1):
		movable.append(grid_pos + Vector2(0,2) * team)
