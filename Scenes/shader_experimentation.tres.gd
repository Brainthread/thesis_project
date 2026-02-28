extends Node3D

func _process(delta):
	rotate(Vector3.UP, delta/5); 
	#rotate(Vector3.UP, delta*1/7);
