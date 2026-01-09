extends CharacterState

const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 8.0

var speed: float = 0

func enter() -> void:
	if character_state_machine.current_state.name == "walk":
		speed = WALK_SPEED
		
	if character_state_machine.current_state.name == "sprint":
		speed = SPRINT_SPEED

func physics_update(delta: float) -> void:
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction : Vector3 = (camera_mount.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Add the gravity.
	character_body_3d.velocity += character_body_3d.get_gravity() * delta
	
	character_body_3d.velocity.x = lerp(character_body_3d.velocity.x, direction.x * speed, delta * 3.0)
	character_body_3d.velocity.z = lerp(character_body_3d.velocity.z, direction.z * speed, delta * 3.0)
	
	if character_body_3d.is_on_floor():
		character_state_machine.change_state("idle")
		
	character_body_3d.move_and_slide()
