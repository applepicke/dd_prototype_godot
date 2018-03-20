extends KinematicBody2D

var StateMachine = load("res://Scripts/StateMachine.gd")

var GRAVITY = 50
var deadzone = 0.5
var motion = Vector2()
var move_speed = 250
var roll_speed = 150

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
	pass

func _ready():
	animator = find_node('AnimationPlayer')
	state_machine = StateMachine.new(self, Idle, animator, {
		Idle: find_node("Idle"),
		Run: find_node("Run")
	})
	
	sprite = find_node("Sprite")


func _process(delta):
	state_machine.process(delta)	
#	
#	var light_attack_pressed = Input.is_action_just_pressed("light_attack")
#	var heavy_attack_pressed = Input.is_action_just_pressed("heavy_attack")
#	var roll_pressed = Input.is_action_just_pressed("roll")
#
#
#	if light_attack_pressed:
#		change_state(SM.LightAttack)
#	if heavy_attack_pressed:
#		change_state(SM.HeavyAttack)
#	if roll_pressed:
#		change_state(SM.Roll)
#
#	if current_state == SM.LightAttack:
#		yield(animator, "animation_finished")
#		change_state(SM.Idle)
#	elif current_state == SM.HeavyAttack:
#		yield(animator, "animation_finished")
#		change_state(SM.Idle)
#	elif current_state == SM.Roll:
#		yield(animator, "animation_finished")
#		change_state(SM.Idle)
		
		
func _physics_process(delta):
	state_machine.physics_process(delta)
	
	motion.y = delta + 10 * GRAVITY
	
#	if current_state == SM.Roll:
#		move_and_slide(Vector2(flip_h, 0) * roll_speed)

	move_and_slide(motion)

func get_movement():
	var x = Input.get_joy_axis(0, 0)
	
	if abs(x) > deadzone:
		return x * move_speed
	
	return 0
	
func move(x):
	motion.x = x


#func change_state(state):
#	if current_state == state:
#		return
#
#	match state:
#		SM.Idle:
#			animator.play("idle")
#		SM.Run:
#			animator.play("run")
#		SM.Roll:
#			animator.play("roll")
#		SM.LightAttack:
#			animator.play("light_attack")
#		SM.HeavyAttack:
#			animator.play("heavy_attack")
#
#	current_state = state
#