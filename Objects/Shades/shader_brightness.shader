shader_type canvas_item;

uniform float brightness : hint_range(0.0, 1.0, 0.1);
uniform float contrast : hint_range(0.0, 1.0, 0.1);
uniform float saturation : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
	c.rgb = mix(vec3(0.5), c.rgb, contrast);
	c.rgb = mix(vec3(dot(vec3(1.0), c.rgb)*0.33333), c.rgb, saturation);
	
	COLOR.rgb = c;
}