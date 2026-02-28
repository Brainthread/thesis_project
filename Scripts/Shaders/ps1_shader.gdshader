shader_type spatial;
render_mode skip_vertex_transform, unshaded;


group_uniforms Basic;
uniform sampler2D my_texture : source_color, filter_nearest, repeat_disable;
uniform vec3 tint : source_color = vec3(1);
uniform bool vertex_snap = true;
uniform bool goraud_shaded = false;
group_uniforms;

uniform bool use_fog = true;
global uniform vec4 fog_color;
global uniform float fog_start;
global uniform float fog_end;

global uniform bool do_affine_texture_mapping;
global uniform vec2 resolution;
global uniform float depth_quantization;
global uniform int color_depth;

varying vec4 clip_position;

varying float FOG_EFFECT;

void vertex() {
	mat4 model_matrix = MODEL_MATRIX;
	vec4 world_space_pos = model_matrix * vec4(VERTEX, 1);
	vec4 view_pos = VIEW_MATRIX * world_space_pos;
	vec4 clip_pos = PROJECTION_MATRIX * view_pos;
	if (vertex_snap) {
		clip_pos.xy = floor(clip_pos.xy / clip_pos.w * resolution) / resolution * clip_pos.w;
	}
	POSITION = clip_pos;
	clip_position = clip_pos;
	NORMAL = MODEL_NORMAL_MATRIX * NORMAL;

	float view_distance = length(CAMERA_POSITION_WORLD - world_space_pos.xyz);
	FOG_EFFECT = (fog_end - (view_distance)) / (fog_end - fog_start);
	FOG_EFFECT = 1.0 - clamp(FOG_EFFECT, 0.0, 1.0);

	if (do_affine_texture_mapping == true) {
		UV *= clip_pos.w;
		COLOR *= clip_pos.w;
		FOG_EFFECT *= clip_pos.w;
	}
}

void fragment() {
	vec2 uv = UV;
	vec3 vertex_color = COLOR.rgb;
	float fog_effect = FOG_EFFECT;
	if(do_affine_texture_mapping) {
		uv /= clip_position.w;
		vertex_color /= clip_position.w;
		fog_effect /= clip_position.w;
	}
	vec3 texture_color = texture(my_texture, uv).rgb;
	vec3 albedo = texture_color * vertex_color * tint;
	
	if(use_fog)
	{
		albedo = mix(albedo, fog_color.xyz, fog_effect);
		albedo = clamp(albedo, vec3(0), vec3(1));
	}
	
	vec3 srgb = pow(max(albedo, 0.0), vec3(1.0 / 2.2));
	float dpth = float(color_depth);
    float steps = pow(2.0, dpth) - 1.0;
    vec3 quantized = floor(srgb * steps + 0.5) / steps;
    albedo = pow(quantized, vec3(2.2));

	ALBEDO = albedo;
}

void light() {
	DIFFUSE_LIGHT = vec3(1);
	SPECULAR_LIGHT = vec3(0);
}