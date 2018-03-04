extends KinematicBody2D

var GRAVITY = 50
var deadzone = 0.5
var motion = Vector2()
var move_speed = 250
var roll_speed = 150

var animator
var sprite

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

func _process(delta):
	motion.x = 0
	var x = Input.get_joy_axis(0, 0)
	var light_attack_pressed = Input.is_action_just_pressed("light_attack")
	var heavy_attack_pressed = Input.is_action_just_pressed("heavy_attack")
	var roll_pressed = Input.is_action_just_pressed("roll")

	
	if light_attack_pressed:
		change_state(SM.LightAttack)
	if heavy_attack_pressed:
		change_state(SM.HeavyAttack)
	if roll_pressed:
		change_state(SM.Roll)
		
	if current_state == SM.LightAttack:
		yield(animator, "animation_finished")
		change_state(SM.Idle)
	elif current_state == SM.HeavyAttack:
		yield(animator, "animation_finished")
		change_state(SM.Idle)
	elif current_state == SM.Roll:
		yield(animator, "animation_finished")
		change_state(SM.Idle)
	elif abs(x) > deadzone:
		motion.x = x * move_speed
		sprite.set_flip_h(x < 0)
		change_state(SM.Run)
	else:
		change_state(SM.Idle)
		
		
func _physics_process(delta):
	motion.y = delta + 10 * GRAVITY
	
	var flip_h = -1 if sprite.flip_h else 1 
		
	if current_state == SM.Roll:
		move_and_slide(Vector2(flip_h, 0) * roll_speed)
		
	move_and_slide(motion)
		
		
func change_state(state):
	if current_state == state:
		return
	
	match state:
		SM.Idle:
			animator.play("idle")
		SM.Run:
			animator.play("run")
		SM.Roll:
			animator.play("roll")
		SM.LightAttack:
			animator.play("light_attack")
		SM.HeavyAttack:
			animator.play("heavy_attack")
			
	current_state = state
			