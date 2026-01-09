extends CharacterState


func physics_update(_delta: float) -> void:
	
	var inputDirection : Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction : Vector3 = (camera_mount.transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction and character_body_3d.is_on_floor():
		character_state_machine.change_state("walk")
