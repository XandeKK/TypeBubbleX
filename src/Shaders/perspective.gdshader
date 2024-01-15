// This shader is adapted from https://www.shadertoy.com/view/lsVSWW

shader_type canvas_item;
// comment out render_mode if the texture doesn't come
// from the transparent subviewport
render_mode blend_premul_alpha;

uniform vec2 top_left = vec2(0.0, 0.0);
uniform vec2 top_right = vec2(0.0, 0.0);
uniform vec2 bottom_left = vec2(0.0, 0.0);
uniform vec2 bottom_right = vec2(0.0, 0.0);

float sross(in vec2 a, in vec2 b) {
    return a.x * b.y - a.y * b.x;
}

vec2 invBilinear(in vec2 p, in vec2 a, in vec2 b, in vec2 c, in vec2 d) {
    vec2 e = b - a;
    vec2 f = d - a;
    vec2 g = a - b + c - d;
    vec2 h = p - a;
        
    float k2 = sross(g, f);
    float k1 = sross(e, f) + sross(h, g);
    float k0 = sross(h, e);

    float w = k1*k1 - 4.0*k0*k2;
    
    if(w < 0.0) return vec2(-1.0);

    w = sqrt(w);
    
    float v1 = (-k1 - w) / (2.0 * k2);
    float v2 = (-k1 + w) / (2.0 * k2);
    float u1 = (h.x - f.x * v1) / (e.x + g.x * v1);
    float u2 = (h.x - f.x * v2) / (e.x + g.x * v2);
    bool  b1 = v1 > 0.0 && v1 < 1.0 && u1 > 0.0 && u1 < 1.0;
    bool  b2 = v2 > 0.0 && v2 < 1.0 && u2 > 0.0 && u2 < 1.0;
    
    vec2 res = vec2(-1.0);

    if( b1 && !b2) res = vec2(u1, v1);
    if(!b1 &&  b2) res = vec2(u2, v2);
    
    return res;
}

void fragment() {
    vec2 top_left_UV = top_left / vec2(textureSize(TEXTURE, 0));
    vec2 top_right_UV = vec2(1.0,0.0) + top_right / vec2(textureSize(TEXTURE, 0));
    vec2 bottom_right_UV = vec2(1.0,1.0) + bottom_right / vec2(textureSize(TEXTURE, 0));
    vec2 bottom_left_UV = vec2(0.0,1.0) + bottom_left / vec2(textureSize(TEXTURE, 0));

    vec2 new_UV = invBilinear(UV, top_left_UV, top_right_UV, bottom_right_UV, bottom_left_UV);
    
    if (top_left == vec2(0.0, 0.0) && top_right == vec2(0.0, 0.0) && bottom_left == vec2(0.0, 0.0) && bottom_right == vec2(0.0, 0.0)) {
        COLOR = texture(TEXTURE,UV);
    }else{
        if (new_UV == vec2(-1.0,-1.0)) {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        } else {
            COLOR = texture(TEXTURE, new_UV);
        }
    }
}
