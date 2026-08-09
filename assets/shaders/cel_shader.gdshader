shader_type spatial;
render_mode cuts_per_pixel, specular_toon;

uniform vec4 albedo_color : source_color = vec4(0.8, 0.8, 0.85, 1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;

uniform vec4 specular_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float glossiness : hint_range(1.0, 128.0) = 32.0;

uniform vec4 rim_color : source_color = vec4(0.3, 0.7, 1.0, 1.0);
uniform float rim_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float rim_smoothness : hint_range(0.0, 0.5) = 0.05;

// Quantization steps for Toon lighting
uniform int toon_steps = 3;

void fragment() {
	vec4 tex_color = texture(texture_albedo, UV);
	ALBEDO = albedo_color.rgb * tex_color.rgb;
	ROUGHNESS = 0.8;
	METALLIC = 0.0;
}

void light() {
	// 1. Quantized Diffuse Toon Lighting
	float NdotL = dot(NORMAL, LIGHT);
	float light_intensity = max(0.0, NdotL);
	
	// Step quantization
	float step_size = 1.0 / float(toon_steps);
	float toon_diffuse = floor(light_intensity / step_size + 0.5) * step_size;
	toon_diffuse = clamp(toon_diffuse, 0.15, 1.0); // Ambient light minimum floor
	
	vec3 diffuse = ALBEDO * LIGHT_COLOR * toon_diffuse * ATTENUATION;

	// 2. Toon Specular Highlight
	vec3 half_vector = normalize(VIEW + LIGHT);
	float NdotH = max(0.0, dot(NORMAL, half_vector));
	float spec_intensity = pow(NdotH, glossiness);
	float toon_specular = step(0.5, spec_intensity);
	
	vec3 specular = specular_color.rgb * LIGHT_COLOR * toon_specular * ATTENUATION;

	// 3. Stylized Rim Light (Anti-AI Painterly outline glow)
	float NdotV = 1.0 - max(0.0, dot(NORMAL, VIEW));
	float rim_intensity = smoothstep(rim_threshold - rim_smoothness, rim_threshold + rim_smoothness, NdotV * NdotL);
	vec3 rim = rim_color.rgb * rim_intensity * LIGHT_COLOR * ATTENUATION;

	DIFFUSE_LIGHT += diffuse + specular + rim;
}
