extends Node

var config=ConfigFile.new()
const SETTINGS_FILE_PATH="user://settings.ini"


func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybiding", "up", "W")
		config.set_value("keybiding", "down", "S")
		config.set_value("keybiding", "left", "A")
		config.set_value("keybiding", "right", "D")

		config.set_value("video", "resolution_index", 0)
		config.set_value("video", "window_mode_index", 0)

		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)

		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

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
