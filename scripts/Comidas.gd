extends Node2D

func add(p):
	p.position = Vector2(get_child_count()%3 * 50, floor(get_child_count()/3) * 50)
	add_child(p)
