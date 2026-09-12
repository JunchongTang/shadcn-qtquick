#version 440

// 2x upsample with a 3x3 tent filter. Bilinear alone leaves visible quad edges
// when magnifying a heavily reduced level; the tent reconstructs a smooth
// gradient instead, which is what keeps a large blur looking continuous.

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

    vec4 result = texture(source, uv + vec2(-1.0,  1.0) * t) * 1.0
                + texture(source, uv + vec2( 0.0,  1.0) * t) * 2.0
                + texture(source, uv + vec2( 1.0,  1.0) * t) * 1.0
                + texture(source, uv + vec2(-1.0,  0.0) * t) * 2.0
                + texture(source, uv)                        * 4.0
                + texture(source, uv + vec2( 1.0,  0.0) * t) * 2.0
                + texture(source, uv + vec2(-1.0, -1.0) * t) * 1.0
                + texture(source, uv + vec2( 0.0, -1.0) * t) * 2.0
                + texture(source, uv + vec2( 1.0, -1.0) * t) * 1.0;

    fragColor = result * (1.0 / 16.0) * qt_Opacity;
}
