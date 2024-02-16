extends RayCast3D

var looking_at : Object = null

func _process(delta: float) -> void:
	var object = get_collider()
	
	if object != looking_at:
		if object != null and "targeted" in object:
			object.targeted = true;
		if looking_at != null and "targeted" in looking_at:
			looking_at.targeted = false
		
		looking_at = object
