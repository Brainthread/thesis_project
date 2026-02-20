shader_type canvas_item;

global uniform int scale_factor;
global uniform int color_depth;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void fragment() {
    vec2 grid_uv = floor(FRAGCOORD.xy / float(scale_factor)) * float(scale_factor);
    vec3 c = texture(SCREEN_TEXTURE, grid_uv * SCREEN_PIXEL_SIZE).rgb;

    vec3 srgb = pow(max(c, 0.0), vec3(1.0 / 2.2));
	float dpth = float(color_depth);
    float steps = pow(2.0, dpth) - 1.0;
    vec3 quantized = floor(srgb * steps + 0.5) / steps;
    c = pow(quantized, vec3(2.2));

    COLOR = vec4(c, 1.0);
}