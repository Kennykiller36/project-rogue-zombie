extends Button
class_name InputMapBtn

@export var action: String
@export var action_event_index := 0

func _ready():
	toggle_mode = true
	toggled.connect(_on_toggled)
	_update_text()

func _on_toggled(pressed: bool):
	if pressed:
		text = "Awaiting input"
	else:
		_update_text()

func _update_text():
	if not action or not InputMap.has_action(action):
		text = "Invalid"
		return

	var events := InputMap.action_get_events(action)
	if action_event_index >= events.size():
		text = "Unassigned"
		return

	var ev := events[action_event_index]
	if ev is InputEventKey:
		text = OS.get_keycode_string(ev.physical_keycode)

func _unhandled_input(event: InputEvent):
	if not button_pressed:
		return
	if not (event is InputEventKey):
		return
	if not event.pressed:
		return

	# Enforce single key per action
	InputMap.action_erase_events(action)

	var new_event := InputEventKey.new()
	new_event.physical_keycode = event.physical_keycode
	InputMap.action_add_event(action, new_event)

	ConfigFileHandler.save_input_map()

	set_pressed(false)
	release_focus()
	_update_text()

func _input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		if not get_global_rect().has_point(event.position):
			set_pressed(false)
			release_focus()
			_update_text()
