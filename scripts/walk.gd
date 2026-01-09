extends CharacterState

const WALK_SPEED: float = 5.0

# headbob variables
var bob_freq: float =  2.0
var bob_amp: float = 0.08
var t_bob: float = 0.0

func physics_update(delta: float) -> void:
	
	var inputDirection : Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction : Vector3 = (camera_mount.transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction:
		character_body_3d.velocity.x = direction.x * WALK_SPEED
		character_body_3d.velocity.z = direction.z * WALK_SPEED
	else:
		character_body_3d.velocity.x = lerp(character_body_3d.velocity.x, direction.x * WALK_SPEED, delta * 7.0)
		character_body_3d.velocity.z = lerp(character_body_3d.velocity.z, direction.z * WALK_SPEED, delta * 7.0)
		
	t_bob += delta * character_body_3d.velocity.length() * float(character_body_3d.is_on_floor())
	camera_3d.transform.origin = headbob(t_bob)

	if !direction:
		character_state_machine.change_state("idle")
	
	character_body_3d.move_and_slide()


func headbob(time: float) ->Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos
