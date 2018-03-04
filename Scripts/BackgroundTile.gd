extends Node2D

var last_camera_x = 0
var player
var camera
var light_far
var light_near

var trees_2
var trees_3
var trees_4

func _ready():
	light_far = get_node("LightsFar")
	light_near = get_node("LightsNear")

	trees_2 = get_node("Trees2")
	trees_3 = get_node("Trees3")
	trees_4 = get_node("Trees4")
	
	player = get_node("../../Player")
	camera = get_node("../../Player/Camera2D")

func _physics_process(delta):
	var new_x = camera.get_camera_position().x
	var x = new_x - last_camera_x
	last_camera_x = new_x
	
	if x != 0:
		light_far.translate(Vector2(x * 0.05, 0))
		light_near.translate(Vector2(x * 0.2, 0))

		trees_2.translate(Vector2(x * 0.02, 0))
		trees_3.translate(Vector2(x * 0.03, 0))
		trees_4.translate(Vector2(x * 0.05, 0))
		
func reset_positions():
	var items = [
		light_far,
		light_near,
		trees_2,
		trees_3,
		trees_4,
	]
	
	for item in items:
		item.set_transform(Transform2D(0, Vector2(0, item.transform.origin.y)))
