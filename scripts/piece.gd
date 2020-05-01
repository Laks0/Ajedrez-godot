extends KinematicBody2D

const move_texture = preload("res://assets/Move.png")

var grid_pos = Vector2()

var sel = false # Está seleccionado

var movable = [Vector2(0,0),Vector2(1,0)] # Todas las casillas a las que se puede mover la pieza

onready var Board = get_parent()

func set_up(_team, _g_pos):
	add_to_group(str(_team))
	grid_pos = _g_pos

func _ready():
	update_position(grid_pos)
	
	if is_in_group("1"):
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
	sel = true
	set_movable()

	for pos in movable: # Crea un Sprite en Temp por cada posición a la que se puede mover la pieza
		var s = Sprite.new()
		s.texture = move_texture
		s.position = Board.map_to_world(pos) + Vector2(50, 50) - position
		# La posición tiene que compensar el offset y la posición de la pieza
		$Temp.add_child(s)
