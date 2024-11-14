shader_type canvas_item;
render_mode blend_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform int blur_size : hint_range(0,30);

void fragment() {
	 COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, float(blur_size)/10.0);
}