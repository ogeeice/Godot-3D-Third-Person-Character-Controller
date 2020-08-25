extends KinematicBody

var direction = Vector3()
var velocity = Vector3()

export var gravity = -27
export var jump_height = 15
export var walk_speed = 15


onready var body = get_node("player_mesh")

export var MOUSE_SENSITIVITY = 0.3
onready var head = $head
onready var camera = $head/Camera_Bone/Kamera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.set_window_position(Vector2(0,0))


func _input(event):

	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY
		head.rotation_degrees.x -= event.relative.y * MOUSE_SENSITIVITY
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-60,60)
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _process(delta):
	direction = Vector3()
	var top = $head/Camera.get_global_transform().basis
	if Input.is_action_pressed("forward"):
		direction -= top.z
	if Input.is_action_pressed("backward"):
		direction += top.z
	if Input.is_action_pressed("left"):
		direction -= top.x
	if Input.is_action_pressed("right"):
		direction += top.x
	direction = direction.normalized()
	velocity.y += gravity * delta
	var tv = velocity
	tv = velocity.linear_interpolate(direction * walk_speed,6 * delta)
	velocity.x = tv.x
	velocity.z = tv.z
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
