extends Node

var _animation = ""
var _animator
var _parent
var _state_machine

func init(state_machine, parent, animator):
	_animator = animator
	_parent = parent
	_state_machine = state_machine
	
func state_changed():
	_animator.play(_animation)
	
func change_state(new_state):
	_state_machine.change_state(new_state)
	
func set_animation(animation):
	_animation = animation	
	
	
	
# Called when state is initialized and properties are set
func ready():
	pass
	
# Called when receiving input
func input():
	pass

# Called once per frame
func process(delta):
	pass
	
# Called in consistent intervals
func physics_process(delta):
	pass
	
