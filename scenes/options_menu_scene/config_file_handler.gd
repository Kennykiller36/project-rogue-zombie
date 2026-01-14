extends Node

var config=ConfigFile.new()
const SETTINGS_FILE_PATH="user://settings.ini"


const GAME_ACTIONS := [
	"up",
	"down",
	"left",
	"right"
]


const DICIONARIO_RESOLUCAO:Dictionary={
	"1152 x 648": Vector2i(1152,648),
	"1280 x 720": Vector2i(1280,720),
	"1920 x 1080": Vector2i(1920,1080),
	"1920 x 1200": Vector2i(1920,1200)
}

const MODO_JANELA_ARRAY: Array[String]=[
	"Tela cheia", "Janela", "Janela sem borda", "Tela cheia sem borda"
]


func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "up", "W")
		config.set_value("keybinding", "down", "S")
		config.set_value("keybinding", "left", "A")
		config.set_value("keybinding", "right", "D")

		config.set_value("video", "resolution_index", 0)
		config.set_value("video", "window_mode_index", 0)

		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)

		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

	# Apply settings on startup
	apply_video_settings()
	apply_audio_settings()
	apply_input_map()

func save_video_setting(key: String, value):
	config.set_value("video", key, value)
	var err = config.save(SETTINGS_FILE_PATH)
	if err != OK:
		print("Error saving video setting (%s): %s" % [key, err])

func load_video_settings() -> Dictionary:
	var video_settings := {}
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		var err = config.load(SETTINGS_FILE_PATH)
		if err == OK and config.has_section("video"):
			for key in config.get_section_keys("video"):
				video_settings[key] = config.get_value("video", key)
		else:
			print("Error loading video settings: ", err)
	return video_settings


func save_audio_settings(key:String, volume):
	if typeof(volume) != TYPE_FLOAT:
		push_error("Audio volume must be float, got: %s" % typeof(volume))
		return

	config.set_value("audio", key, volume)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings() -> Dictionary:
	var audio_settings := {}
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		var err = config.load(SETTINGS_FILE_PATH)
		if err == OK:
			if config.has_section("audio"):
				for key in config.get_section_keys("audio"):
					audio_settings[key] = config.get_value("audio", key)
		else:
			print("Error loading config: ", err)

	return audio_settings

func apply_window_mode(index: int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func apply_resolution(index: int):
	if index < DICIONARIO_RESOLUCAO.values().size():
		DisplayServer.window_set_size(DICIONARIO_RESOLUCAO.values()[index])

func apply_video_settings():
	var video_settings = load_video_settings()
	if video_settings.has("window_mode_index"):
		apply_window_mode(video_settings["window_mode_index"])
	if video_settings.has("resolution_index"):
		apply_resolution(video_settings["resolution_index"])

func set_audio_volume(bus_name: String, volume: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		var db = linear_to_db(volume)
		AudioServer.set_bus_volume_db(bus_index, db)

func apply_audio_settings():
	var audio_settings = load_audio_settings()
	if audio_settings.has("master_volume"):
		set_audio_volume("Master", audio_settings["master_volume"])
	if audio_settings.has("sfx_volume"):
		set_audio_volume("Sfx", audio_settings["sfx_volume"])
	if audio_settings.has("music_volume"):
		set_audio_volume("Musica", audio_settings["music_volume"])

func save_input_map():
	for action in GAME_ACTIONS:
		if not InputMap.has_action(action):
			continue

		var events := InputMap.action_get_events(action)
		if events.size() > 0 and events[0] is InputEventKey:
			config.set_value("keybinding", action, events[0].physical_keycode)

	config.save(SETTINGS_FILE_PATH)

func apply_input_map():
	if not config.has_section("keybinding"):
		return

	for action in config.get_section_keys("keybinding"):
		if not InputMap.has_action(action):
			continue

		InputMap.action_erase_events(action)

		var ev := InputEventKey.new()
		ev.physical_keycode = int(config.get_value("keybinding", action))
		InputMap.action_add_event(action, ev)
