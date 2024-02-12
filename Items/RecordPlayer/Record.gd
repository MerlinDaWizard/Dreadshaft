extends Node3D


@export_file("*.mp3","*.wav")
var audio_file: String

enum States {GROUND, ATTACHING, PLAYING}
var state: States = States.GROUND
var initial_transform: Transform3D
var attach_time: float = 0.0
var record_player: Node3D = null

func _process(delta: float) -> void:
	if state == States.ATTACHING:
		attach_time = min(attach_time+delta*2.0, 1.0)
		
		transform = initial_transform.interpolate_with(Transform3D.IDENTITY, _basic_smoothstep(attach_time))
		if attach_time == 1:
			state = States.PLAYING
			attach_time = 0.0
			record_player.start_record(audio_file)
	elif state == States.PLAYING:
		# Negative because recors spin clockwise
		rotate_y(deg_to_rad(-10*delta))
	
func _basic_smoothstep(f: float) -> float:
	return f*f*(3.0-2.0*f)
