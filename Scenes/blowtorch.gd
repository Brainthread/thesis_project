extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Flame.visible = false
	get_parent_node_3d().button_pressed.connect(_on_controller_trigger_pressed)
	get_parent_node_3d().button_released.connect(_on_controller_trigger_released)
	$RayCast3D.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("fire_torch")):
		_start_torch()
	if(Input.is_action_just_released("fire_torch")):
		_stop_torch()
	if $RayCast3D.enabled:
		if $RayCast3D.is_colliding() && $RayCast3D.get_collider() != null:
			$RayCast3D.get_collider().deal_damage(_delta)

func _start_torch():
	$Flame.visible = true
	$RayCast3D.enabled = true
	$AudioStreamPlayer3D.play()

func _stop_torch():
	$Flame.visible = false
	$RayCast3D.enabled = false
	$AudioStreamPlayer3D.stop()
	
func _on_controller_trigger_pressed(_button_name):
	if _button_name == "trigger_click":
		_start_torch()

func _on_controller_trigger_released(_button_name):
	if _button_name == "trigger_click":
		_stop_torch()
