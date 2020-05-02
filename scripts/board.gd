extends TileMap

export (PackedScene) var Peon
export (PackedScene) var Caballo
export (PackedScene) var Alfil
export (PackedScene) var Dama
export (PackedScene) var Rey
export (PackedScene) var Torre

var grid = []

var turn = -1 # Turno, -1 = blancas, 1 = negras

func _ready():
	for x in range (0,8):
		var t = []
		for y in range (0,8):
			t.append(null)
		grid.append(t)
	
	inicial()

func _process(delta):
	var click = Input.is_action_just_released("Click")
	
	if click:
		var mouse_pos = get_mouse_on_grid()
		var p = grid[mouse_pos.x][mouse_pos.y]
		if p != null: # Si se clickeó una casilla con una pieza
			if p.team == turn: # Si es su turno
				p.new_sel() # Seleccionarla

func spawn_piece(piece, pos, team):
	var p = piece.instance()
	p.set_up(team, pos)
	grid[pos.x][pos.y] = p
	add_child(p)

func move_piece(from, to):
	var pfrom = grid[from.x][from.y]
	if grid[to.x][to.y] != null: # Verificar si la casilla está ocupada
		grid[to.x][to.y].kill() # Comer la pieza que la ocupa
	
	grid[to.x][to.y] = pfrom
	grid[from.x][from.y] = null
	pfrom.update_position(to)
	end_turn()

func end_turn():
	turn = -turn

func get_mouse_on_grid():
	return world_to_map(get_global_mouse_position())

func at_grid(pos):
	return grid[pos.x][pos.y]

func inside_grid(vector):
	return vector.x >= 0 and vector.x < 8 and vector.y >= 0 and vector.y < 8 

func inicial(): # Posicion inicial
	# Peones
	for x in range(0, 8):
		spawn_piece(Peon, Vector2(x, 6), -1)
		spawn_piece(Peon, Vector2(x, 1), 1)
	# Torres
	for x in range(0,2):
		spawn_piece(Torre, Vector2(x * 7, 7), -1)
		spawn_piece(Torre, Vector2(x * 7, 0), 1)
	# Caballos
	for x in range(0,2):
		spawn_piece(Caballo, Vector2(1 + x * 5, 7), -1)
		spawn_piece(Caballo, Vector2(1 + x * 5, 0), 1)
	# Alfiles
	for x in range(0,2):
		spawn_piece(Alfil, Vector2(2 + x * 3, 7), -1)
		spawn_piece(Alfil, Vector2(2 + x * 3, 0), 1)
	# Damas
	spawn_piece(Dama, Vector2(3, 7), -1)
	spawn_piece(Dama, Vector2(4, 0), 1)
	# Reyes
	spawn_piece(Rey, Vector2(4, 7), -1)
	spawn_piece(Rey, Vector2(3, 0), 1)
