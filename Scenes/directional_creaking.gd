extends AudioStreamPlayer3D

var sound_events : Dictionary[float, AudioEvent]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in sound_events.keys():
		if sound_events[n].played == false && delta > n:
			stream = sound_events[n].audio
			position = sound_events[n].position
			play()
	pass
