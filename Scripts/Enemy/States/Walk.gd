extends "res://Scripts/State.gd"

var enemy

func ready():
	enemy = self._parent
	set_animation("walk")

	
func process(delta):
	enemy.move(0)

