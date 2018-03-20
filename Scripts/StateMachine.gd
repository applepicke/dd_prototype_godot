extends Node

var _parent
var _current_state
var _animator
var _states

func _init(parent, initial_state, animator, states):
	_parent = parent
	_states = states
	_animator = animator
	
	for state in states.values():
		initialize_state(state)
	
	change_state(initial_state)

func input():
	pass

func process(delta):
	_states[_current_state].process(delta)
	
func physics_process(delta):
	_states[_current_state].physics_process(delta)
	
func initialize_state(state):
	state.init(self, _parent, _animator)
	state.ready()
	
func change_state(new_state):
	if new_state != _current_state:
		_current_state = new_state
		print(new_state)
		print(_states.keys())
		_states[_current_state].state_changed()