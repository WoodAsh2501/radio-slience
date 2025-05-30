class_name State

extends Node

@onready var state_machine = get_parent()

func get_state_machine() -> StateMachine:
	return state_machine

func get_current_state() -> State:
	return state_machine.get_current_state() as State

func enter(_data):
	pass

func exit():
	pass

func state_process(_delta):
	pass

func switch_to(state_name, data: Dictionary = {}):
	state_machine.switch_to(state_name, data)