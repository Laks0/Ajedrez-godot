extends "res://scripts/piece.gd"

func set_movable():
	movable = check_in_direction(1,1)
	for i in check_in_direction(-1,1):
		movable.append(i)
	for i in check_in_direction(-1,-1):
		movable.append(i)
	for i in check_in_direction(1,-1):
		movable.append(i)
