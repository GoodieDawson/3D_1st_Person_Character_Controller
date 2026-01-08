class_name CharacterStateMachine 

extends Node

@export var initial_state: CharacterState

var current_state: CharacterState
var states: Dictionary[String, CharacterState] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children: Array[CharacterState]
	for child in get_children():
		if child is CharacterState:
			children.append(child)
	for child in children:
		child.character_state_machine = self
		states[child.name.to_lower()] = child
		
	initial_state.enter()
	current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func change_state(new_state_string: String) -> void:
	var new_state: CharacterState = states.get(new_state_string)
	
	current_state.exit()
	new_state.enter()
	
	current_state = new_state
	
	print(current_state.name)
