class_name StateMachine

extends Node

signal state_changed(previous_state, current_state)

@export var initial_state: State
var current_state_name: String
var previous_state_name: String
var current_state: State
var states_dict = {}

func _ready() -> void:
    # 添加所有状态
    for child in get_children():
        if child is State:
            states_dict[child.name] = child
    
    if states_dict.size() > 0:
        current_state = initial_state
        current_state_name = current_state.name

func switch_to(state_name, data: Dictionary = {}):
    if state_name in states_dict:
        var previous_state = current_state
        previous_state_name = previous_state.name
        previous_state.exit()
        
        current_state = states_dict[state_name]
        current_state_name = current_state.name
        current_state.enter(data)
        emit_signal("state_changed", previous_state_name, current_state_name)
    else:
        print("State not found: ", state_name)

func get_state():
    return current_state

func get_state_name():
    return current_state_name

func is_state(state_name: String) -> bool:
    return current_state_name == state_name