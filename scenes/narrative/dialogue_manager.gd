extends Node
class_name DialogueManager

signal dialogue_started(speaker_name: String, text: String)
signal dialogue_advanced(speaker_name: String, text: String)
signal dialogue_ended

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
	var speaker = first_line.get("speaker", "Stimme") if typeof(first_line) == TYPE_DICTIONARY else "Stimme"
	var text = first_line.get("text", "") if typeof(first_line) == TYPE_DICTIONARY else ""
	dialogue_started.emit(speaker, text)

func advance_dialogue() -> void:
	if not is_active:
		return
		
	current_line_index += 1
	if current_line_index < current_queue.size():
		var line = current_queue[current_line_index]
		var speaker = line.get("speaker", "Stimme") if typeof(line) == TYPE_DICTIONARY else "Stimme"
		var text = line.get("text", "") if typeof(line) == TYPE_DICTIONARY else ""
		dialogue_advanced.emit(speaker, text)
	else:
		_end_dialogue()

func _end_dialogue() -> void:
	is_active = false
	current_queue.clear()
	dialogue_ended.emit()
