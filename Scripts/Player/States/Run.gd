extends "res://Scripts/State.gd"

var player

func ready():
	player = self._parent
	set_animation("run")
	
func process(delta):
	var x = player.get_movement()
	
	if x == 0:
		self.change_state(player.States.Idle)
	else:
		player.sprite.set_flip_h(x < 0) 
		player.move(x)
