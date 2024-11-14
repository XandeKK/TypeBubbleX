shader_type canvas_item;

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    float intensity = (col.r + col.g + col.b) / 3.0;
    col.a = 1.0 - intensity;

    COLOR = col;
}