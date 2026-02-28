extends StaticBody3D
class_name BreachNode

var active = true
var id:int = -1
var max_health = 10
var health:float = 10
var scl_ratio:float = 0.3
var original_scale:Vector3
var emitting_set_this_frame = false

signal destroyed(id:int)

func _ready() -> void:
	health = max_health
	original_scale = $CSGSphere3D.scale

func set_id(value):
	id = value

func _process(delta: float) -> void:
	#deal_damage(delta)
	if emitting_set_this_frame == false:
		$GPUParticles3D2.emitting = false
	if emitting_set_this_frame:
		emitting_set_this_frame = false


func deal_damage(value):
	if $CSGSphere3D.visible:
		health -= value;
		$GPUParticles3D2.emitting = true
		emitting_set_this_frame = true
		$CSGSphere3D.scale = original_scale - scl_ratio * (original_scale * (1-(health/max_health)))
		if(health < 0):
			destroyed.emit(id)
			$CSGSphere3D.visible = false
			$AudioStreamPlayer3D.pitch_scale *= randf_range(0.95, 1.05)
			$AudioStreamPlayer3D.play()
			$GPUParticles3D.emitting = true
