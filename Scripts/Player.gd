extends KinematicBody2D

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

# func _input(event):
# 	if event.is_action_pressed("jump"):
# 		speed_y = -JUMP_FORCE

func _physics_process(delta):
	motion.x = 0
	var x = Input.get_joy_axis(0, 0)
	var flip_h = -1 if sprite.flip_h else 1

	var light_attack_pressed = Input.is_action_just_pressed("light_attack")
	var heavy_attack_pressed = Input.is_action_just_pressed("heavy_attack")
	var roll_pressed = Input.is_action_just_pressed("roll")
	var jump_pressed = Input.is_action_just_pressed("jump")

	if abs(x) < deadzone:
		x = 0

	if light_attack_pressed:
		change_state(SM.LightAttack)
	if heavy_attack_pressed:
		change_state(SM.HeavyAttack)
	if roll_pressed:
		change_state(SM.Roll)
	if jump_pressed and current_state != SM.Jump:
		speed_y = -JUMP_FORCE
		jumping = true
		change_state(SM.Jump)

	# set speeds
	match current_state:
		SM.Roll:
			speed_x = flip_h * roll_speed
		SM.LightAttack:
			motion.x = 0
		SM.HeavyAttack:
			motion.x = 0
		SM.Jump:
			pass
		_:
			if x != 0:
				sprite.set_flip_h(x < 0)
				speed_x = x * move_speed * delta
			else:
				speed_x = 0


	speed_y += GRAVITY * delta

	motion.y = speed_y * delta
	motion.x = speed_x * delta

	move_and_slide(motion)

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

