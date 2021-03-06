extends KinematicBody2D

const move_texture = preload("res://assets/Move.png")

var grid_pos = Vector2()
var team
var sel = false # Está seleccionado
var team_normal

var movable = [] # Todas las casillas a las que se puede mover la pieza

onready var Board = get_parent()

func set_up(_team, _g_pos):
	team = _team
	team_normal = sign(team - 1)
	grid_pos = _g_pos
	add_to_group(str(_team))

func _ready():
	update_position(grid_pos)
	
	if team == 1:
		$Sprite.modulate = Color(.2,.2,.2)

func _process(delta):
	var click = Input.is_action_just_pressed("Click")
	if sel and click: # Si se selecciona
		var mouse_position = Board.get_mouse_on_grid()
		for i in movable:
			if mouse_position == i: # Si se puede mover a la casilla
				Board.move_piece(grid_pos, i)
				break
		unsel()

func set_movable():
	pass

func kill():
	Board.remove_child(self)
	Board.comidas[-team_normal].add(self)

func remove_temp():
	for t in $Temp.get_children():
		$Temp.remove_child(t)

func update_position(_g_pos): # Ponerse en la posición de la grilla
	position = Board.map_to_world(_g_pos)
	grid_pos = _g_pos

func unsel():
	sel = false
	remove_temp()

func new_sel(): # Se llama cada vez que la pieza es seleccionada
	movable = []
	sel = true
	set_movable()
	
	check()
	
	for pos in movable: # Crea un Sprite en Temp por cada posición a la que se puede mover la pieza
		var s = Sprite.new()
		s.texture = move_texture
		s.z_index = 1
		s.modulate = Color(1,1,1,.6)
		s.position = Board.map_to_world(pos) + Vector2(50, 50) - position
		# La posición tiene que compensar el offset y la posición de la pieza
		$Temp.add_child(s)

func check():
	var to_remove = [] # Movimientos a eliminar
	
	var oldBoard = Board.get_grid() # Guardar una copia del tablero
	for pos in movable: # Por cada posibilidad
		# Crear un tablero hipotético del movimiento
		Board.to_grid(pos, self)
		Board.clear_grid(grid_pos)
		
		var king_pos # La posición del rey en el tablero hipotético
		var enemies = []
		for x in Board.grid:
			for p in x:
				if p != null:
					if p.is_in_team(team) and p.is_in_group("Rey"): king_pos = p.grid_pos
					if p.is_in_team(-team): enemies.append(p)
		if is_in_group("Rey"): king_pos = pos
		
		for e in enemies: # Por cada enemigo
			e.set_movable()
			for threat in e.movable: # Por cada posibilidad de movimiento enemigo
				if threat == king_pos: # Si se amenaza al rey
					to_remove.append(pos)
					break
		
		Board.grid = oldBoard.duplicate(true) # Volver al tablero real
	
	for i in to_remove:
		movable.erase(i)

# Herramientas para definir movimientos
func check_in_direction(x,y): # Para seguir en una linea recta
	var moves = []
	var currentPos = grid_pos + Vector2(x,y) # La posicion a chequear
	
	while Board.inside_grid(currentPos): # Mientras esté dentro del tablero
		var cell = Board.at_grid(currentPos)
		if cell == null: # Si no está vacío
			moves.append(currentPos)
			currentPos += Vector2(x,y)
		else:
			if cell.team != team: # Si es del otro equipo
				moves.append(currentPos)
				currentPos += Vector2(x,y)
			break
	
	return moves

func is_in_team(t):
	return is_in_group(str(t))

func clear_parent():
	get_parent().remove_child(self)
