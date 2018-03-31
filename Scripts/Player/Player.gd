extends KinematicBody2D

var StateMachine = load("res://Scripts/StateMachine.gd")

var GRAVITY = 50
var deadzone = 0.5
var motion = Vector2()
var move_speed = 250
var roll_speed = 200

var animator
var sprite

var state_machine

enum States {
	Idle,
	Run,
	LightAttack,
	HeavyAttack,
	Roll,
	Jump
}

func _input(event):
	if event.is_action("roll"):
		state_machine.change_state(States.Roll)
	if event.is_action("light_attack"):
		state_machine.change_state(States.LightAttack)
	if event.is_action_pressed("heavy_attack"):
		state_machine.change_state(States.HeavyAttack)

func _ready():
	animator = find_node('AnimationPlayer')
	state_machine = StateMachine.new(self, Idle, animator, {
		Idle: find_node("Idle"),
		Run: find_node("Run"),
		Roll: find_node("Roll"),
		LightAttack: find_node("LightAttack"),
		HeavyAttack: find_node("HeavyAttack"),
	})
	
	sprite = find_node("Sprite")


func _process(delta):
	state_machine.process(delta)	


func _physics_process(delta):
	state_machine.physics_process(delta)
	
	motion.y = delta + 10 * GRAVITY

	move_and_slide(motion)

func get_movement():
	var x = Input.get_joy_axis(0, 0)
	
	if abs(x) > deadzone:
		return x * move_speed
	
	return 0
	
func move(x):
	motion.x = x
