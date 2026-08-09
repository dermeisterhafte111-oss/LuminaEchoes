extends CanvasLayer
class_name DialogueBox

@onready var panel: PanelContainer = $Control/PanelContainer
@onready var speaker_label: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/SpeakerLabel
@onready var text_label: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/TextLabel

var tween: Tween

func _ready() -> void:
	if panel:
		panel.hide()

func show_line(speaker: String, content: String) -> void:
	if not panel:
		return
		
	panel.show()
	speaker_label.text = speaker
	text_label.text = content
	text_label.visible_characters = 0
	
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	var char_count = content.length()
	tween.tween_property(text_label, "visible_characters", char_count, char_count * 0.03)

func hide_dialogue() -> void:
	if panel:
		panel.hide()

func _input(event: InputEvent) -> void:
	if panel and panel.visible and event.is_action_just_pressed("interact"):
		if text_label.visible_characters < text_label.text.length():
			# Fast-forward text
			if tween: tween.kill()
			text_label.visible_characters = text_label.text.length()
		else:
			hide_dialogue()
