extends "res://scripts/piece.gd"

var moved = false

func move():
	if !moved:
		print(team_normal)
		var y = 7*(-team_normal)
		if grid_pos == Vector2(2, y):
			Board.move_grid(Vector2(0, y), Vector2(3, y))
		if grid_pos == Vector2(6, y):
			Board.move_grid(Vector2(7, y), Vector2(5, y))
	
	moved = true

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
	
	if enrocable(1):
		movable.append(grid_pos + Vector2(2, 0))
	if enrocable(-1):
		movable.append(grid_pos - Vector2(2, 0))

func enrocable(dir): # Si se puede enrocar
	if !moved: # Si nunca se movio
		var _pos = grid_pos + Vector2(dir, 0)
		while Board.inside_grid(_pos):
			var p = Board.at_grid(_pos)
			if p != null: # Si no está vacía
				if _pos.x == 7 * sign(dir + 1) and p.is_in_group("Torre"): # Si está en el borde y es una torre
					return true
				else:
					break
			_pos += Vector2(dir, 0)
	return false
