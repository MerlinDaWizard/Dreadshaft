extends Node3D

@export
var attached_record: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func attach_record(record: RigidBody3D) -> bool:
	if attached_record:
		return false
	
	print("Attaching!")
	record.set_collision_layer_value(1, false)
	record.freeze = true
	record.reparent($RecordLockPoint)
	record.set_position(Vector3.ZERO)
	record.rotation=Vector3.ZERO
	
	$AudioStreamPlayer3D.set_stream(ResourceLoader.load(record.audio_file))
	$AudioStreamPlayer3D.play()
	attached_record = record
	return true


func _on_area_3d_body_entered(body: Node3D) -> void:
	attach_record(body)
	pass # Replace with function body.
