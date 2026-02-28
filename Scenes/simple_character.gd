extends Node3D

@export var parameter_handler:ParameterHandler
@export var camera:Camera3D
var look_rotation:Vector2
var sensitivity:float = 0.5
var min_x_angle = -90
var max_x_angle = 90


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion && parameter_handler.settings_visible == false:
		look_rotation.y -= (event.relative.x * sensitivity)
		look_rotation.x -= (event.relative.y * sensitivity)
		look_rotation.x = clamp(look_rotation.x, min_x_angle, max_x_angle)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y
	if(Input.is_key_pressed(KEY_W)):
		position -= transform.basis.z * 1 * delta
	if(Input.is_key_pressed(KEY_S)):
		position += transform.basis.z * 1 * delta
	if(Input.is_key_pressed(KEY_A)):
		position -= transform.basis.x * 1 * delta
	if(Input.is_key_pressed(KEY_D)):
		position += transform.basis.x * 1 * delta
	if position.z < -2.56:
		position.z = -2.56
	if position.z > 2.56:
		position.z = 2.56
	if position.x < -1.657:
		position.x = -1.657
	if position.x > 1.657:
		position.x = 1.657
