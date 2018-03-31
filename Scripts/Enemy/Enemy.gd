extends KinematicBody2D

var StateMachine = load("res://Scripts/StateMachine.gd")

var GRAVITY = 50
var motion = Vector2()
var move_speed = 200

var animator
var sprite

var state_machine

enum States {
	Idle,
	Walk
}

func _ready():
	animator = find_node('AnimationPlayer')
	state_machine = StateMachine.new(self, Idle, animator, {
		Idle: find_node("Idle"),
		Walk: find_node("Walk"),
	})
	
	sprite = find_node("Sprite")


func _process(delta):
	state_machine.process(delta)	


func _physics_process(delta):
	state_machine.physics_process(delta)
	
	motion.y = delta + 10 * GRAVITY

	move_and_slide(motion)
	
func move(x):
	motion.x = x
