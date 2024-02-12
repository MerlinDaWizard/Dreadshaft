extends RigidBody3D

class_name PickupableProp

const ANGULAR_DAMP: float = 10.0

const CONTAINER_MASK_ATTACH_MODE: int = 6
const CONTAINER_MASK_DETACH_MODE: int = 7


@export var snap_velocity = 20.0
@export var let_go_distance = 0.8

var prop_container: Node3D

#Outline Object Nonsese
@onready var next_pass_shader : ShaderMaterial = $MeshInstance3D.mesh.material.next_pass
var targeted : bool = false : set = _set_targeted

func _process(delta):
	if prop_container:
		move(delta)
		
	
func attach(causer: Node3D):
	#collision_mask = CONTAINER_MASK_ATTACH_MODE
	prop_container = causer
	angular_damp = ANGULAR_DAMP
	
func detach():
	#collision_mask = CONTAINER_MASK_DETACH_MODE
	prop_container = null
	angular_damp = -1


func move(delta):
	var direction: Vector3 = global_position.direction_to(prop_container.global_position).normalized()
	var distance: float = global_position.distance_to(prop_container.global_position)
	
	set_linear_velocity(direction * snap_velocity *distance)

	if distance > let_go_distance:
		detach()

func _set_targeted(val : bool) -> void:
	targeted = val
	
	if next_pass_shader:
		if targeted:
			next_pass_shader.set_shader_parameter("outline_width", 3.0)
		else:
			next_pass_shader.set_shader_parameter("outline_width", 0.0)
