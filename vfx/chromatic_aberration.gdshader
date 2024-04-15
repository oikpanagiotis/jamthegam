shader_type canvas_item;

uniform bool apply = true;
uniform float amount = 1.0;
uniform sampler2D offset_texture: hint_default_white;
uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
	if (apply == true) {
		float adjusted_amount = amount * texture(offset_texture, UV).r / 100.0;
		color.r = texture(screen_texture, vec2(UV.x + adjusted_amount, UV.y)).r;
		color.g = texture(screen_texture, UV).r;
		color.b = texture(screen_texture, vec2(UV.x - adjusted_amount, UV.y)).b;
	}
	COLOR = color;
}