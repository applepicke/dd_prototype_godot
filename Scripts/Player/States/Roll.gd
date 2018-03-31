extends "res://Scripts/State.gd"

var player

func ready():
	player = self._parent
	self.set_animation("roll", player.States.Idle)
	
func process(delta):
	var dir = -1 if player.sprite.flip_h else 1
	player.move(dir * player.roll_speed)

