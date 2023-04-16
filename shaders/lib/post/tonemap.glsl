// vec3 tonemap_Tech(const in vec3 color) {
//     const float c = rcp(TONEMAP_CONTRAST);
//     vec3 a = color * min(vec3(1.0), 1.0 - exp(-c * color));
//     a = mix(a, color, color * color);
//     return a / (a + 0.6);
// }

void setLuminance(inout vec3 color, const in float targetLuminance) {
    color *= (targetLuminance / luminance(color));
}

vec3 tonemap_ReinhardExtendedLuminance(in vec3 color, const in float maxWhiteLuma) {
    float luma_old = luminance(color);
    float numerator = luma_old * (1.0 + luma_old / _pow2(maxWhiteLuma));
    float luma_new = numerator / (1.0 + luma_old);
    setLuminance(color, luma_new);
    return color;
}

void ApplyPostProcessing(inout vec3 color) {
    #ifdef TONEMAP_ENABLED
        color = tonemap_ReinhardExtendedLuminance(color, 1.5);
    #endif

    #if POST_SATURATION != 100
        #ifndef IRIS_FEATURE_SSBO
            mat3 matColorPost = GetSaturationMatrix(PostSaturationF);
        #endif

        color = matColorPost * color;
    #endif

    color = LinearToRGB(color);
    //color += Bayer16(gl_FragCoord.xy) / 255.0;
}
