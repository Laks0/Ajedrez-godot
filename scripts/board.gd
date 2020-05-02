extends TileMap

export (PackedScene) var Piece

var grid = []

var turn = -1 # Turno, -1 = blancas, 1 = negras

func _ready():
	for x in range (0,8):
		var t = []
		for y in range (0,8):
			t.append(null)
		grid.append(t)
	
	var p = Piece.instance()
	p.set_up(-1, Vector2(2,7))
	add_child(p)
	grid[2][7] = p
	
	var p2 = Piece.instance()
	p2.set_up(1, Vector2(3,1))
	add_child(p2)
	grid[3][1] = p2

func _process(delta):
	var click = Input.is_action_just_released("Click")
	
	if click:
		var mouse_pos = get_mouse_on_grid()
		var p = grid[mouse_pos.x][mouse_pos.y]
		if p != null: # Si se clickeó una casilla con una pieza
			if p.team == turn: # Si es su turno
				p.new_sel() # Seleccionarla

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
