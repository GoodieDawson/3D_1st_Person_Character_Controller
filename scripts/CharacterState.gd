class_name CharacterState 

extends Node

var character_state_machine: CharacterStateMachine
@export var character_body_3d: CharacterBody3D
@export var camera_mount: Node3D
@export var camera_3d: Camera3D


func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
