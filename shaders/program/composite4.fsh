#define RENDER_TRANSLUCENT_RT_LIGHT
#define RENDER_COMPOSITE
#define RENDER_FRAG

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

in vec2 texcoord;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D noisetex;
uniform sampler2D BUFFER_DEFERRED_COLOR;
uniform usampler2D BUFFER_DEFERRED_DATA;
uniform sampler2D TEX_LIGHTMAP;

#if MATERIAL_SPECULAR != SPECULAR_NONE
    uniform sampler2D BUFFER_ROUGHNESS;
#endif

#if !(defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE)
    uniform sampler2D shadowcolor0;
#endif

uniform float frameTime;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;

uniform int heldItemId;
uniform int heldItemId2;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;
uniform bool firstPersonCamera;
uniform vec3 eyePosition;
uniform vec3 upPosition;
uniform vec3 fogColor;

uniform float blindness;

#ifdef WORLD_SKY_ENABLED
    uniform vec3 sunPosition;
    uniform float rainStrength;
    uniform vec3 skyColor;
#endif

#if defined WORLD_SHADOW_ENABLED
    uniform vec3 shadowLightPosition;
#endif

#ifdef WORLD_WATER_ENABLED
    uniform int isEyeInWater;
#endif

#ifdef IS_IRIS
    uniform bool isSpectator;
#endif

#ifdef IRIS_FEATURE_SSBO
    #include "/lib/buffers/scene.glsl"
#endif

#include "/lib/sampling/depth.glsl"
#include "/lib/sampling/noise.glsl"
#include "/lib/sampling/ign.glsl"
#include "/lib/world/common.glsl"
//#include "/lib/world/fog.glsl"

#include "/lib/blocks.glsl"
#include "/lib/items.glsl"

#if MATERIAL_SPECULAR != SPECULAR_NONE
    #include "/lib/material/specular.glsl"
#endif

#if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #ifdef DYN_LIGHT_FLICKER
        #include "/lib/lighting/blackbody.glsl"
        #include "/lib/lighting/flicker.glsl"
    #endif

    #include "/lib/lights.glsl"
    #include "/lib/buffers/lighting.glsl"
    #include "/lib/lighting/voxel/mask.glsl"
    #include "/lib/lighting/voxel/lights.glsl"
    #include "/lib/lighting/voxel/blocks.glsl"
    #include "/lib/lighting/voxel/items.glsl"
#endif

#if DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #include "/lib/buffers/collissions.glsl"
    #include "/lib/lighting/voxel/collisions.glsl"
    #include "/lib/lighting/voxel/tinting.glsl"
    #include "/lib/lighting/voxel/tracing.glsl"
#endif

#include "/lib/lighting/fresnel.glsl"
#include "/lib/lighting/sampling.glsl"

#if defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #include "/lib/lighting/voxel/sampling.glsl"
#endif

#ifdef WORLD_SKY_ENABLED
    #include "/lib/world/sky.glsl"
#endif

#include "/lib/lighting/basic_hand.glsl"
#include "/lib/lighting/basic.glsl"


#if DYN_LIGHT_RES == 1
    const ivec2 offsetList[4] = ivec2[](
        ivec2(0, 0),
        ivec2(1, 0),
        ivec2(0, 1),
        ivec2(1, 1));
#elif DYN_LIGHT_RES == 2
    const ivec2 offsetList[16] = ivec2[](
        ivec2(0, 0),
        ivec2(2, 0),
        ivec2(0, 2),
        ivec2(2, 2),

        ivec2(1, 0),
        ivec2(3, 0),
        ivec2(1, 2),
        ivec2(3, 2),

        ivec2(0, 1),
        ivec2(1, 1),
        ivec2(0, 3),
        ivec2(1, 3),

        ivec2(1, 1),
        ivec2(3, 1),
        ivec2(1, 3),
        ivec2(3, 3));
#endif

#if DYN_LIGHT_RES != 0
    ivec2 GetTemporalOffset(const in int size) {
        int i = int(frameCounter + gl_FragCoord.x + size*gl_FragCoord.y);
        return offsetList[i % _pow2(size)];
    }
#endif


/* RENDERTARGETS: 4,5,6,11 */
layout(location = 0) out vec4 outDiffuse;
layout(location = 1) out vec4 outNormal;
layout(location = 2) out vec4 outDepth;
#if MATERIAL_SPECULAR != SPECULAR_NONE
    layout(location = 3) out vec4 outSpecular;
#endif

void main() {
    vec2 viewSize = vec2(viewWidth, viewHeight);
    const int resScale = int(exp2(DYN_LIGHT_RES));

    vec2 tex2 = texcoord;
    #if DYN_LIGHT_TA > 0 //&& DYN_LIGHT_PENUMBRA > 0
        vec2 pixelSize = rcp(viewSize);

        #if DYN_LIGHT_RES == 2
            tex2 += GetTemporalOffset(4) * pixelSize * 0.25;
        #elif DYN_LIGHT_RES == 1
            tex2 += GetTemporalOffset(2) * pixelSize * 0.5;
        #endif
    #endif

    float depth = textureLod(depthtex0, tex2, 0).r;
    //float handClipDepth = textureLod(depthtex2, tex2, 0).r;
    //bool isHand = handClipDepth > depth;
    
    // if (handClipDepth > depth) {
    //     depth = depth * 2.0 - 1.0;
    //     depth /= MC_HAND_DEPTH;
    //     depth = depth * 0.5 + 0.5;
    // }

    outDepth = vec4(vec3(depth), 1.0);

    float opacity = textureLod(BUFFER_DEFERRED_COLOR, tex2, 0).a;

    if (opacity > (0.5/255.0)) {
        float depthOpaque = textureLod(depthtex1, tex2, 0).r;

        ivec2 iTex = ivec2(tex2 * viewSize);
        uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, iTex, 0);
        vec4 deferredNormal = unpackUnorm4x8(deferredData.r);
        vec4 deferredLighting = unpackUnorm4x8(deferredData.g);
        //vec4 deferredFog = unpackUnorm4x8(deferredData.b);

        vec3 localNormal = deferredNormal.xyz;
        if (any(greaterThan(localNormal.xyz, EPSILON3)))
            localNormal = normalize(localNormal * 2.0 - 1.0);

        vec4 deferredTexture = unpackUnorm4x8(deferredData.a);
        vec3 texNormal = deferredTexture.xyz;

        if (any(greaterThan(texNormal, EPSILON3)))
            texNormal = normalize(texNormal * 2.0 - 1.0);

        float roughL = 1.0;
        float metal_f0 = 0.04;
        float sss = deferredNormal.w;

        #if MATERIAL_SPECULAR != SPECULAR_NONE
            vec2 specularMap = texelFetch(BUFFER_ROUGHNESS, iTex, 0).rg;
            roughL = max(_pow2(specularMap.r), ROUGH_MIN);
            metal_f0 = specularMap.g;
        #endif

        vec3 clipPos = vec3(texcoord, depth) * 2.0 - 1.0;

        #ifndef IRIS_FEATURE_SSBO
            vec3 viewPos = unproject(gbufferProjectionInverse * vec4(clipPos, 1.0));
            vec3 localPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
        #else
            vec3 localPos = unproject(gbufferModelViewProjectionInverse * vec4(clipPos, 1.0));
        #endif

        vec3 blockDiffuse = vec3(0.0);
        vec3 blockSpecular = vec3(0.0);
        GetFinalBlockLighting(blockDiffuse, blockSpecular, localPos, localNormal, texNormal, deferredLighting.x, roughL, metal_f0, sss);
        //blockDiffuse *= 1.0 - deferredFog.a;

        SampleHandLight(blockDiffuse, blockSpecular, localPos, localNormal, texNormal, roughL, metal_f0, sss);

        #if MATERIAL_SPECULAR != SPECULAR_NONE
            if (metal_f0 >= 0.5) {
                vec3 deferredAlbedo = texelFetch(BUFFER_DEFERRED_COLOR, iTex, 0).rgb;
                blockDiffuse *= mix(MaterialMetalBrightnessF, 1.0, roughL);
                blockSpecular *= RGBToLinear(deferredAlbedo);
            }
        #endif

        if (!all(lessThan(abs(texNormal), EPSILON3)))
            texNormal = texNormal * 0.5 + 0.5;

        outDiffuse = vec4(blockDiffuse, 1.0);
        outNormal = vec4(texNormal, 1.0);

        #if MATERIAL_SPECULAR != SPECULAR_NONE
            outSpecular = vec4(blockSpecular, roughL);
        #endif
    }
    else {
        outDiffuse = vec4(0.0, 0.0, 0.0, 1.0);
        outNormal = vec4(0.0, 0.0, 0.0, 1.0);

        #if MATERIAL_SPECULAR != SPECULAR_NONE
            outSpecular = vec4(0.0, 0.0, 0.0, 1.0);
        #endif
    }
}
