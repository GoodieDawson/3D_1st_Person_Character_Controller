extends CharacterBody3D


const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 8.0
const JUMP_VELOCITY: float = 4.5

var speed: float
var sensitivity: int = 1

# headbob variables
var bob_freq: float =  2.0
var bob_amp: float = 0.08
var t_bob: float = 0.0

# fov change variables
var base_fov: float = 75.0
var fov_multiplier: float = 1.5

@onready var camera_mount: Node3D = $CameraMount
@onready var camera_3d: Camera3D = $CameraMount/Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouseMotion: InputEventMouseMotion = event as InputEventMouseMotion
		camera_mount.rotate_y(deg_to_rad(-mouseMotion.relative.x) * sensitivity)
		camera_3d.rotate_x(deg_to_rad(-mouseMotion.relative.y) * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (camera_mount.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _headbob(t_bob)
	
	# FOV Change
	var velocity_clamped: float = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov: float = base_fov + fov_multiplier * velocity_clamped
	camera_3d.fov = lerp(camera_3d.fov, target_fov, delta * 8.0)
	move_and_slide()

func _headbob(time: float) ->Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos
