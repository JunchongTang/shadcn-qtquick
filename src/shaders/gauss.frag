#version 440

// One direction of a separable gaussian, run at the top of the pyramid where
// sigma is always small (<= 3 texels). Weights are evaluated from sigma rather
// than baked, and the kernel reaches +/-10 texels -- past 3 sigma in every
// case -- so the tail is never truncated into ringing.
//
// `direction` is exactly one texel of the sampled texture, never a larger
// stride: sampling wider than a texel is what leaves gaps in the kernel and
// turns a blur into concentric ghosting.

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float sigma;
    vec2 direction;
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    float s = max(sigma, 0.0001);
    float denom = 2.0 * s * s;

    vec4 sum = texture(source, qt_TexCoord0);
    float weightSum = 1.0;

    for (int i = 1; i <= 10; ++i) {
        float fi = float(i);
        float w = exp(-(fi * fi) / denom);
        vec2 offset = direction * fi;
        sum += (texture(source, qt_TexCoord0 + offset)
              + texture(source, qt_TexCoord0 - offset)) * w;
        weightSum += 2.0 * w;
    }

    fragColor = sum / weightSum * qt_Opacity;
}
