extends TileMap

export (PackedScene) var Peon
export (PackedScene) var Caballo
export (PackedScene) var Alfil
export (PackedScene) var Dama
export (PackedScene) var Rey
export (PackedScene) var Torre

var grid = []

onready var comidas = [get_parent().get_node("Eaten_white"), 
get_parent().get_node("Eaten_black")]

var prev_grid
var eaten

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
		if inside_grid(mouse_pos):
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
	prev_grid = get_grid()
	eaten = null
	
	if grid[to.x][to.y] != null: # Verificar si la casilla está ocupada
		eaten = grid[to.x][to.y]
		grid[to.x][to.y].kill() # Comer la pieza que la ocupa
	
	move_grid(from, to)
	
	end_turn()

func move_grid(from, to):
	var pfrom = grid[from.x][from.y]
	grid[to.x][to.y] = pfrom
	
	grid[from.x][from.y] = null
	pfrom.update_position(to)
	
	if pfrom.has_method("move"):
		pfrom.move()

func end_turn():
	turn = -turn
	
	# Fijarse si hay un jaque mate
	var mate
	for p in get_tree().get_nodes_in_group(str(turn)):
		p.new_sel()
		var movs = p.movable.size()
		p.unsel()
		if movs > 0:
			mate = false
			break
		mate = true
	if mate: mate()

func mate():
	print("mate")

func get_mouse_on_grid():
	return world_to_map(get_global_mouse_position())

func at_grid(pos):
	return grid[pos.x][pos.y]

func to_grid(pos, x):
	grid[pos.x][pos.y] = x

func clear_grid(pos):
	grid[pos.x][pos.y] = null

func inside_grid(vector):
	return vector.x >= 0 and vector.x < 8 and vector.y >= 0 and vector.y < 8

func get_grid():
	return grid.duplicate(true)

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
	spawn_piece(Dama, Vector2(3, 0), 1)
	# Reyes
	spawn_piece(Rey, Vector2(4, 7), -1)
	spawn_piece(Rey, Vector2(4, 0), 1)

func _on_Undo_button_up():
	grid = prev_grid.duplicate(true)
	for x in grid.size():
		for y in grid[0].size():
			var p = grid[x][y]
			if p != null:
				p.update_position(Vector2(x, y))
	if eaten != null:
		eaten.clear_parent()
		add_child(eaten)
		eaten.update_position(eaten.grid_pos)
	turn *= -1
