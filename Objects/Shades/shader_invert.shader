shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0, 0.05);

void fragment() {
	vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	vec4 inverted_color = vec4(1.0 - screen_color.rgb, screen_color.a);
	
	vec4 final_color = mix(screen_color, inverted_color, intensity);
	
	COLOR = final_color;
}