extends KinematicBody2D

var GRAVITY = 50
var deadzone = 0.5
var motion = Vector2()
var move_speed = 1000000
var roll_speed = 30000

var animator
var sprite

var speed_y = 0
var speed_x = 0
var jumping = false
const JUMP_FORCE = 10000
const GRAVITY = 20000

var current_state

enum SM {
	Idle,
	Run,
	LightAttack,
	HeavyAttack,
	Roll,
	Jump
}

func _ready():
	animator = find_node("AnimationPlayer")
	sprite = find_node("Sprite")

func _input(event):
	if event.is_action_pressed("jump"):
		speed_y = -JUMP_FORCE
		jumping = true
		change_state(SM.Jump)
	if event.is_action_pressed("light_attack"):
		change_state(SM.LightAttack)
	if event.is_action_pressed("heavy_attack"):
		change_state(SM.HeavyAttack)
	if event.is_action_pressed("roll"):
		change_state(SM.Roll)

func _process(delta):
	var x = Input.get_joy_axis(0, 0)
	if abs(x) < deadzone:
		x = 0

	# block animations
	match current_state:
		SM.LightAttack:
			yield(animator, "animation_finished")
			change_state(SM.Idle)
		SM.HeavyAttack:
			yield(animator, "animation_finished")
			change_state(SM.Idle)
		SM.Roll:
			yield(animator, "animation_finished")
			change_state(SM.Idle)
		SM.Jump:
			yield(animator, "animation_finished")
			jumping = false
			change_state(SM.Idle)
		_:
			if x != 0 and not jumping:
				change_state(SM.Run)
			else:
				if not jumping:
					change_state(SM.Idle)

func _physics_process(delta):
	motion.x = 0
	var x = Input.get_joy_axis(0, 0)
	var flip_h = -1 if sprite.flip_h else 1

	if abs(x) < deadzone:
		x = 0

	# set speeds
	match current_state:
		SM.Roll:
			speed_x = flip_h * roll_speed
		SM.LightAttack:
			speed_x = 0
			if jumping:
				move_x(x, delta)
		SM.HeavyAttack:
			speed_x = 0
			if jumping:
				move_x(x, delta)
		_:
			move_x(x, delta)

	speed_y += GRAVITY * delta

	motion.y = speed_y * delta
	motion.x = speed_x * delta

	move_and_slide(motion)

func move_x(x, delta):
	if x != 0:
		sprite.set_flip_h(x < 0)
		speed_x = x * move_speed * delta
	else:
		speed_x = 0

func change_state(state):
	if current_state == state:
		return

	match state:
		SM.Idle:
			animator.play("idle")
		SM.Run:
			animator.play("run")
		SM.Jump:
			animator.play("jump")
		SM.Roll:
			animator.play("roll")
		SM.LightAttack:
			animator.play("light_attack")
		SM.HeavyAttack:
			animator.play("heavy_attack")

	current_state = state

