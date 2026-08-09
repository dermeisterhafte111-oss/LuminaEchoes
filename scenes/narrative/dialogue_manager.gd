extends Node
class_name DialogueManager

signal dialogue_started(speaker_name: String, text: String)
signal dialogue_advanced(speaker_name: String, text: String)
signal dialogue_ended

struct DialogueLine:
	var speaker: String
	var text: String

var current_queue: Array = []
var is_active: bool = false
var current_line_index: int = 0

func start_dialogue(lines: Array) -> void:
	if lines.is_empty():
		return
		
	current_queue = lines
	current_line_index = 0
	is_active = true
	
	var first_line = current_queue[0]
	dialogue_started.emit(first_line.get("speaker", "Stimme"), first_line.get("text", ""))

func advance_dialogue() -> void:
	if not is_active:
		return
		
	current_line_index += 1
	if current_line_index < current_queue.size():
		var line = current_queue[current_line_index]
		dialogue_advanced.emit(line.get("speaker", "Stimme"), line.get("text", ""))
	else:
		_end_dialogue()

func _end_dialogue() -> void:
	is_active = false
	current_queue.clear()
	dialogue_ended.emit()
