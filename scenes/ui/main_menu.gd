extends Control

@onready var main_buttons_vbox: VBoxContainer = $MarginContainer/VBoxContainer/MainButtons
@onready var settings_panel: PanelContainer = $SettingsPanel
@onready var sensitivity_slider: HSlider = $SettingsPanel/MarginContainer/VBoxContainer/SensHBox/SensSlider
@onready var volume_slider: HSlider = $SettingsPanel/MarginContainer/VBoxContainer/VolHBox/VolSlider
@onready var fullscreen_check: CheckBox = $SettingsPanel/MarginContainer/VBoxContainer/FullscreenCheck

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if settings_panel:
		settings_panel.hide()

func _on_start_button_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	if SceneTransition:
		SceneTransition.change_scene("res://scenes/levels/main_level.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/main_level.tscn")

func _on_settings_button_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	if settings_panel:
		settings_panel.show()
		main_buttons_vbox.hide()

func _on_close_settings_button_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	if settings_panel:
		settings_panel.hide()
		main_buttons_vbox.show()

func _on_quit_button_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_hover")

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vol_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
