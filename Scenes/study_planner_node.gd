extends Node3D
class_name StudyPlanner

@export var breach_nodes : Array[BreachNode]
@export var test_node : BreachNode
var breach_times : Array[float]
var stage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	breach_times.resize(breach_nodes.size())
	for n in breach_nodes.size():
		breach_nodes[n].set_id(n)
		breach_nodes[n].destroyed.connect(on_destroy_node)
	test_node.visible = false
	for node in breach_nodes:
			node.visible = false

func on_destroy_node(node_number):
	breach_nodes[node_number] = null
	print(node_number, " destroyed! T=", breach_times[node_number])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stage == 2:
		for n in breach_nodes.size():
			if breach_nodes[n] != null:
				breach_times[n] += delta
	if Input.is_action_just_pressed("advance"):
		stage += 1
		if stage == 1:
			test_node.visible = true
		if stage == 2:
			for node in breach_nodes:
				node.visible = true
