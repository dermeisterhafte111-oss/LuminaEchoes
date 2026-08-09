extends CanvasLayer
class_name HUD

@onready var reticle: TextureRect = $Control/Reticle
@onready var spectrum_label: Label = $Control/SpectrumPanel/MarginContainer/HBoxContainer/SpectrumLabel
@onready var spectrum_color_rect: ColorRect = $Control/SpectrumPanel/MarginContainer/HBoxContainer/ColorIndicator
@onready var objective_label: Label = $Control/ObjectivePanel/MarginContainer/ObjectiveLabel

func update_spectrum_indicator(is_spectrum_b: bool) -> void:
	if not spectrum_label or not spectrum_color_rect:
		return
		
	var tween = create_tween().set_parallel(true)
	if is_spectrum_b:
		spectrum_label.text = "SPEKTRUM B: ECHO"
		tween.tween_property(spectrum_color_rect, "color", Color(0.95, 0.70, 0.25, 1.0), 0.3)
	else:
		spectrum_label.text = "SPEKTRUM A: GEGENWART"
		tween.tween_property(spectrum_color_rect, "color", Color(0.15, 0.65, 0.95, 1.0), 0.3)

func set_objective_text(text: String) -> void:
	if objective_label:
		objective_label.text = "ZIEL: " + text

func set_reticle_highlight(highlight: bool) -> void:
	if reticle:
		var target_scale = Vector2(1.4, 1.4) if highlight else Vector2(1.0, 1.0)
		create_tween().tween_property(reticle, "scale", target_scale, 0.15)
