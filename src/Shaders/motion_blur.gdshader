shader_type canvas_item;
render_mode blend_premul_alpha;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
// Experience-Monks' fast gaussian blur function
// Link: https://github.com/Experience-Monks/glsl-fast-gaussian-blur/
//
// BLUR ITERATIONS (Default 16.0 - More is better but slower)
// BLUR DIRECTION (Direction in which the blur is apllied, use vec2(1, 0) for first pass and vec2(0, 1) for second pass)
//
// Desc.: ACTUALLY PRETTY SLOW but still pretty good for custom cinematic
// bloom effects, since this needs render 2 passes 
vec4 texture_monksgaussian_multipass(sampler2D tex, vec2 uv, vec2 pixel_size, int iterations, vec2 direction){
	vec4 blurred_tex = vec4(0.0);
	vec2 resolution = 1.0 / pixel_size;
	
	for (int i=0; i < iterations; i++){
		float size = float(iterations - i);
		
		vec2 off1 = vec2(1.3846153846) * (direction * size);
		vec2 off2 = vec2(3.2307692308) * (direction * size);

		blurred_tex += texture(tex, uv) * 0.2270270270;
		blurred_tex += texture(tex, uv + (off1 / resolution)) * 0.3162162162;
		blurred_tex += texture(tex, uv - (off1 / resolution)) * 0.3162162162;
		blurred_tex += texture(tex, uv + (off2 / resolution)) * 0.0702702703;
		blurred_tex += texture(tex, uv - (off2 / resolution)) * 0.0702702703;
	}
	
	blurred_tex /= float(iterations) + 1.0;
	
	return blurred_tex;
}

//  -- EXAMPLE CODE -- //
uniform int blur_amount = 16;
uniform vec2 blur_direction = vec2(0, 0);
void fragment(){
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy; 
	
	vec4 monksgaussian_multipass = texture_monksgaussian_multipass(SCREEN_TEXTURE, uv, SCREEN_PIXEL_SIZE, blur_amount, blur_direction);
	COLOR =  monksgaussian_multipass;
}