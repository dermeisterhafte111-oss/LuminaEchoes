shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform vec4 fog_color_near : source_color = vec4(0.05, 0.08, 0.15, 1.0); // Indigo
uniform vec4 fog_color_far : source_color = vec4(0.85, 0.60, 0.30, 1.0);  // Gold / Teal ambient
uniform float fog_density : hint_range(0.0, 1.0) = 0.04;
uniform float fog_start : hint_range(0.0, 100.0) = 5.0;
uniform float fog_end : hint_range(10.0, 500.0) = 80.0;

void fragment() {
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	// Read depth buffer
	float depth_raw = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	
	// Normalize depth calculation for perspective camera projection
	float z_ndc = depth_raw * 2.0 - 1.0;
	// Dynamic depth approximation
	float linear_depth = (2.0 * 0.1 * 100.0) / (100.0 + 0.1 - z_ndc * (100.0 - 0.1));
	
	// Calculate fog factor
	float fog_factor = clamp((linear_depth - fog_start) / (fog_end - fog_start), 0.0, 1.0);
	fog_factor = pow(fog_factor, 1.5) * fog_density * 10.0;
	fog_factor = clamp(fog_factor, 0.0, 0.95);
	
	// Gradient fog blend
	vec4 current_fog_color = mix(fog_color_near, fog_color_far, fog_factor);
	
	// Final composition
	COLOR = mix(screen_color, current_fog_color, fog_factor);
}
