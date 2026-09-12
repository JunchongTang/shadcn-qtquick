#version 440

// 2x downsample with the 13-tap filter from Jimenez's "Next Generation Post
// Processing" (SIGGRAPH 2014). A plain box filter aliases badly on the way
// down, which is what produces the concentric ringing you see when a naive
// blur is pushed to a large radius. The overlapping 2x2 boxes here prefilter
// properly, so each pyramid level is a clean band-limited version of the last.

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 texelSize;
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec2 uv = qt_TexCoord0;
    vec2 t = texelSize;

    vec4 a = texture(source, uv + vec2(-2.0, -2.0) * t);
    vec4 b = texture(source, uv + vec2( 0.0, -2.0) * t);
    vec4 c = texture(source, uv + vec2( 2.0, -2.0) * t);
    vec4 d = texture(source, uv + vec2(-1.0, -1.0) * t);
    vec4 e = texture(source, uv + vec2( 1.0, -1.0) * t);
    vec4 f = texture(source, uv + vec2(-2.0,  0.0) * t);
    vec4 g = texture(source, uv);
    vec4 h = texture(source, uv + vec2( 2.0,  0.0) * t);
    vec4 i = texture(source, uv + vec2(-1.0,  1.0) * t);
    vec4 j = texture(source, uv + vec2( 1.0,  1.0) * t);
    vec4 k = texture(source, uv + vec2(-2.0,  2.0) * t);
    vec4 l = texture(source, uv + vec2( 0.0,  2.0) * t);
    vec4 m = texture(source, uv + vec2( 2.0,  2.0) * t);

    vec4 result = (d + e + i + j) * 0.125
                + (a + b + g + f) * 0.03125
                + (b + c + h + g) * 0.03125
                + (f + g + l + k) * 0.03125
                + (g + h + m + l) * 0.03125;

    fragColor = result * qt_Opacity;
}
