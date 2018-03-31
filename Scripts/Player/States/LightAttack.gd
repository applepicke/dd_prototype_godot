extends "res://Scripts/State.gd"

var player

func ready():
	player = self._parent
	self.set_animation("light_attack", player.States.Idle)

func process(delta):
	player.move(0)
