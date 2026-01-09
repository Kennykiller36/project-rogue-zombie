extends Button
class_name InputMapBtn

@export var action:String
@export var action_event_index: int=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode=true
	toggled.connect(_toggled)
	_toggled(false)

func _toggled(toggled_on: bool) -> void:
	if !action or !InputMap.has_action(action):
		return
	if toggled_on:
		text= "Awaiting input"
		return
	if action_event_index>=InputMap.action_get_events(action).size():
		text= "Unassigned"
		return
	var input= InputMap.action_get_events(action)[action_event_index]
	if input is InputEventKey:
		if input.physical_keycode !=0:
			text=OS.get_keycode_string(input.physical_keycode)
		else:
			text=OS.get_keycode_string(input.keycode)

func _unhandled_input(event: InputEvent) -> void:
	if !InputMap.has_action(action) or !button_pressed:
		return
	if event.is_pressed() and (event is InputEventKey):
		var action_events_list=InputMap.action_get_events(action)
		if action_event_index<action_events_list.size():
			InputMap.action_erase_event(action, action_events_list[action_event_index])
		InputMap.action_add_event(action,event)
		action_event_index=InputMap.action_get_events(action).size()-1
		set_pressed(false)
		release_focus()
		
func _input(event: InputEvent) -> void:
	# Only untoggle if clicking outside the button (mouse button released)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		# Don't untoggle if the mouse is over this button
		if not get_global_rect().has_point(event.position):
			set_pressed(false)
			release_focus()

		
