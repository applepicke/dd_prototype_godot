extends "res://Scripts/State.gd"

var player

func ready():
	player = self._parent
	set_animation("idle")

	
func process(delta):
	if player.get_movement() != 0:
		self.change_state(player.States.Run)
	else:
		player.move(0)
		
	
