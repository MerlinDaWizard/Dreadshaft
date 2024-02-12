extends Node3D

@export
var attached_record: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func try_attach_record(record: RigidBody3D) -> bool:
	if attached_record:
		return false
	
	# Stop the record colliding with the player
	record.set_collision_layer_value(1, false)
	record.set_collision_layer_value(3, false)

	# Remove from players hand if holding
	if record is PickupableProp:
		var prop := record as PickupableProp
		if prop.prop_container:
			# remove from player
			prop.prop_container.get_parent().get_parent().get_parent().held_object = null
			# remove from prop itself
			prop.detach()
	
	# Disable collisions for the record
	record.freeze = true
	record.remove_from_group("Pickupable")
	
	# Reparent but keep current position
	var saved_transform: Transform3D = record.global_transform
	record.reparent($RecordLockPoint)
	record.global_transform = saved_transform
	record.initial_transform = record.transform
	
	
	# Set the records state so it can drift atttach
	record.state = record.States.ATTACHING
	record.record_player = self
	
	attached_record = record
	return true


func _on_area_3d_body_entered(body: Node3D) -> void:
	try_attach_record(body)
	pass
	
func start_record(file: String) -> void:
	$AudioStreamPlayer3D.set_stream(ResourceLoader.load(file))
	$AudioStreamPlayer3D.play()

func eject_record() -> void:
	if attached_record == null or attached_record.state != attached_record.States.PLAYING:
		return
		
	$AudioStreamPlayer3D.stop()
	attached_record.state = attached_record.States.GROUND
	
	var saved_transform: Transform3D = attached_record.global_transform
	attached_record.reparent(self.get_parent())
	attached_record.global_transform = saved_transform
	
	attached_record.set_collision_layer_value(1, true)
	attached_record.freeze = false
	attached_record.add_to_group("Pickupable")
	
	# This is so that we always have atleast 0.5 in a direction.
	# As Vector3(randf(), randf_range(2,3.5), randf()) has a chance to go straight up.
	# But if we did a minimum on each they would alwaays go in a similar direction
	# This is my basically converting from polar co-ords
	var horizontals: Vector2 = Vector2.from_angle(randf()*2*PI)*randf_range(0.75,1.25)
	attached_record.apply_impulse(Vector3(horizontals.x,randf_range(2.25,3.5),horizontals.y))
	
	# So that it doesnt immediately reconnect
	var timer: SceneTreeTimer = get_tree().create_timer(0.75, false, true)
	timer.timeout.connect((func(r: RigidBody3D) -> void: r.set_collision_layer_value(3,true)).bind(attached_record))
	
	attached_record.record_player = null 
	attached_record = null
