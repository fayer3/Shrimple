#define RENDER_ENTITIES
#define RENDER_GBUFFER
#define RENDER_FRAG

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 vPos;
in vec3 vNormal;
in float geoNoL;
in float vLit;
in vec3 vLocalPos;
in vec3 vLocalNormal;
in vec3 vBlockLight;

#if MATERIAL_NORMALS != NORMALMAP_NONE
    in vec3 vLocalTangent;
    in float vTangentW;
#endif

#if MATERIAL_PARALLAX != PARALLAX_NONE
    in vec2 vLocalCoord;
    in vec3 tanViewPos;
    flat in mat2 atlasBounds;

    #if defined WORLD_SKY_ENABLED && defined WORLD_SHADOW_ENABLED
        in vec3 tanLightPos;
    #endif
#endif

#ifdef WORLD_SHADOW_ENABLED
    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
        in vec3 shadowPos[4];
        flat in int shadowTile;
    #elif SHADOW_TYPE != SHADOW_TYPE_NONE
        in vec3 shadowPos;
    #endif
#endif

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;

#if MATERIAL_NORMALS != NORMALMAP_NONE || MATERIAL_PARALLAX != PARALLAX_NONE
    uniform sampler2D normals;
#endif

#if MATERIAL_EMISSION != EMISSION_NONE || MATERIAL_SSS == SSS_LABPBR || MATERIAL_SPECULAR == SPECULAR_OLDPBR || MATERIAL_SPECULAR == SPECULAR_LABPBR
    uniform sampler2D specular;
#endif

#if defined RENDER_TRANSLUCENT && defined IRIS_FEATURE_SSBO && VOLUMETRIC_BLOCK_MODE == VOLUMETRIC_BLOCK_EMIT
    uniform sampler3D texLPV;
#endif

#ifdef WORLD_SHADOW_ENABLED
    uniform sampler2D shadowtex0;
    uniform sampler2D shadowtex1;

    #ifdef SHADOW_ENABLE_HWCOMP
        #ifdef IRIS_FEATURE_SEPARATE_HARDWARE_SAMPLERS
            uniform sampler2DShadow shadowtex0HW;
        #else
            uniform sampler2DShadow shadow;
        #endif
    #endif
#endif

uniform int frameCounter;
uniform float frameTimeCounter;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 upPosition;
uniform vec3 skyColor;
uniform float near;
uniform float far;

uniform vec3 fogColor;
uniform float fogDensity;
uniform float fogStart;
uniform float fogEnd;
uniform int fogShape;
uniform int fogMode;

uniform int entityId;
uniform vec4 entityColor;
uniform float blindness;

#if (defined WORLD_SHADOW_ENABLED && SHADOW_COLORS == 1) || DYN_LIGHT_MODE != DYN_LIGHT_NONE
    uniform sampler2D shadowcolor0;
#endif

#if MATERIAL_PARALLAX != PARALLAX_NONE
    uniform ivec2 atlasSize;
#endif

#ifdef WORLD_SKY_ENABLED
    uniform vec3 sunPosition;
    uniform float rainStrength;
#endif

#if defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
    uniform vec3 shadowLightPosition;

    #if SHADOW_TYPE != SHADOW_TYPE_NONE
        uniform mat4 shadowProjection;
    #endif
#else
    uniform int worldTime;
#endif

//#if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    uniform int heldItemId;
    uniform int heldItemId2;
    uniform int heldBlockLightValue;
    uniform int heldBlockLightValue2;

    #ifdef IS_IRIS
        uniform bool firstPersonCamera;
        uniform vec3 eyePosition;
    #endif
//#endif

#ifdef VL_BUFFER_ENABLED
    uniform mat4 shadowModelView;
    uniform ivec2 eyeBrightnessSmooth;
    uniform int isEyeInWater;
#endif

#if AF_SAMPLES > 1
    uniform float viewWidth;
    uniform float viewHeight;
    uniform vec4 spriteBounds;
#endif

#if MC_VERSION >= 11700
    uniform float alphaTestRef;
#endif

#include "/lib/sampling/depth.glsl"
#include "/lib/sampling/noise.glsl"
#include "/lib/sampling/bayer.glsl"
#include "/lib/sampling/ign.glsl"
#include "/lib/world/common.glsl"
#include "/lib/world/fog.glsl"

#include "/lib/blocks.glsl"
#include "/lib/items.glsl"

#ifdef IRIS_FEATURE_SSBO
    #include "/lib/buffers/scene.glsl"
#else
    #include "/lib/post/saturation.glsl"
#endif

#if MATERIAL_NORMALS != NORMALMAP_NONE || MATERIAL_PARALLAX != PARALLAX_NONE
    #include "/lib/utility/tbn.glsl"
    #include "/lib/sampling/atlas.glsl"
#endif

#if AF_SAMPLES > 1
    #include "/lib/sampling/anisotropic.glsl"
#endif

#if defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
    #include "/lib/buffers/shadow.glsl"

    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
        #include "/lib/shadows/cascaded.glsl"
        #include "/lib/shadows/cascaded_render.glsl"
    #else
        #include "/lib/shadows/basic.glsl"
        #include "/lib/shadows/basic_render.glsl"
    #endif

    #include "/lib/shadows/common_render.glsl"
#endif

#include "/lib/entities.glsl"
#include "/lib/lighting/dynamic_entities.glsl"
#include "/lib/physics_mod/snow.glsl"

#ifdef RENDER_TRANSLUCENT
    #include "/lib/lighting/fresnel.glsl"
#endif

#ifdef DYN_LIGHT_FLICKER
    #include "/lib/lighting/blackbody.glsl"
    #include "/lib/lighting/flicker.glsl"
#endif

#if DYN_LIGHT_MODE != DYN_LIGHT_NONE
    #if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
        #include "/lib/buffers/lighting.glsl"
        #include "/lib/lighting/dynamic.glsl"
        #include "/lib/lighting/dynamic_blocks.glsl"
    #endif

    #if DYN_LIGHT_MODE == DYN_LIGHT_TRACED
        #include "/lib/lighting/collisions.glsl"
        #include "/lib/lighting/tracing.glsl"
    #endif
#endif

#include "/lib/lighting/dynamic_lights.glsl"
#include "/lib/lighting/dynamic_items.glsl"

#include "/lib/material/emission.glsl"
#include "/lib/material/subsurface.glsl"
#include "/lib/material/specular.glsl"

#if MATERIAL_PARALLAX != PARALLAX_NONE
    #include "/lib/sampling/linear.glsl"
    #include "/lib/material/parallax.glsl"
#endif

#if MATERIAL_NORMALS != NORMALMAP_NONE
    #include "/lib/material/normalmap.glsl"
#endif

#include "/lib/lighting/sampling.glsl"
#include "/lib/lighting/basic_hand.glsl"
#include "/lib/lighting/basic.glsl"

#ifdef VL_BUFFER_ENABLED
    #include "/lib/world/volumetric_fog.glsl"
#endif

#include "/lib/post/tonemap.glsl"


#if !defined RENDER_TRANSLUCENT && ((defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE == DYN_LIGHT_TRACED) || (defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE && defined SHADOW_BLUR))
    /* RENDERTARGETS: 1,2,3,14 */
    layout(location = 0) out vec4 outDeferredColor;
    layout(location = 1) out vec4 outDeferredShadow;
    layout(location = 2) out uvec4 outDeferredData;
    #if MATERIAL_SPECULAR != SPECULAR_NONE
        layout(location = 3) out vec4 outDeferredRough;
    #endif
#else
    /* RENDERTARGETS: 0 */
    layout(location = 0) out vec4 outFinal;
#endif

void main() {
    mat2 dFdXY = mat2(dFdx(texcoord), dFdy(texcoord));
    vec2 atlasCoord = texcoord;

    #if MATERIAL_PARALLAX != PARALLAX_NONE
        float texDepth = 1.0;
        vec3 traceCoordDepth = vec3(1.0);
        vec3 tanViewDir = normalize(tanViewPos);
        bool skipParallax = false;
    #endif

    vec4 color;
    if (entityId == ENTITY_PHYSICSMOD_SNOW) {
        color.rgb = GetSnowColor(vLocalPos + cameraPosition) * glcolor.rgb;
        color.a = 1.0;
    }
    else {
        #if MATERIAL_PARALLAX != PARALLAX_NONE
            //bool isMissingNormal = all(lessThan(normalMap.xy, EPSILON2));
            //bool isMissingTangent = any(isnan(vLocalTangent));

            float viewDist = length(vPos);

            if (!skipParallax && viewDist < MATERIAL_PARALLAX_DISTANCE) {
                atlasCoord = GetParallaxCoord(dFdXY, tanViewDir, viewDist, texDepth, traceCoordDepth);
            }

        #endif

        color = textureGrad(gtexture, atlasCoord, dFdXY[0], dFdXY[1]);

        #ifdef RENDER_TRANSLUCENT
            const float alphaThreshold = (1.5/255.0);
        #else
            float alphaThreshold = alphaTestRef;
        #endif

        if (color.a < alphaThreshold) {
            discard;
            return;
        }

        #ifndef RENDER_TRANSLUCENT
            color.a = 1.0;
        #endif

        color.rgb = mix(color.rgb * glcolor.rgb, entityColor.rgb, entityColor.a);
    }

    const float occlusion = 1.0; // glcolor.a
    
    vec3 localNormal = normalize(vLocalNormal);
    if (!gl_FrontFacing) localNormal = -localNormal;

    vec3 localViewDir = -normalize(vLocalPos);

    float roughness, metal_f0;
    float sss = GetMaterialSSS(entityId, atlasCoord);
    float emission = GetMaterialEmission(entityId, atlasCoord);
    GetMaterialSpecular(atlasCoord, -1, roughness, metal_f0);

    vec3 shadowColor = vec3(1.0);
    #if defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
        vec3 localLightDir = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);

        float skyGeoNoL = max(dot(localNormal, localLightDir), 0.0);

        if (skyGeoNoL < EPSILON && sss < EPSILON) {
            shadowColor = vec3(0.0);
        }
        else {
            #if SHADOW_COLORS == SHADOW_COLOR_ENABLED
                shadowColor = GetFinalShadowColor(sss);
            #else
                shadowColor = vec3(GetFinalShadowFactor(sss));
            #endif
        }
    #endif

    vec3 texNormal = localNormal;
    #if MATERIAL_NORMALS != NORMALMAP_NONE
        bool isValidNormal = GetMaterialNormal(atlasCoord, texNormal);

        #if MATERIAL_PARALLAX != PARALLAX_NONE
            if (!skipParallax) {
                #if MATERIAL_PARALLAX == PARALLAX_SHARP
                    float depthDiff = max(texDepth - traceCoordDepth.z, 0.0);

                    if (depthDiff >= ParallaxSharpThreshold) {
                        texNormal = GetParallaxSlopeNormal(atlasCoord, dFdXY, traceCoordDepth.z, tanViewDir);
                        isValidNormal = true;
                    }
                #endif

                #if defined WORLD_SKY_ENABLED && MATERIAL_PARALLAX_SHADOW_SAMPLES > 0
                    if (traceCoordDepth.z + EPSILON < 1.0) {
                        vec3 tanLightDir = normalize(tanLightPos);
                        shadowColor *= GetParallaxShadow(traceCoordDepth, dFdXY, tanLightDir);
                    }
                #endif
            }
        #endif

        if (isValidNormal) {
            vec3 localTangent = normalize(vLocalTangent);
            mat3 matLocalTBN = GetLocalTBN(localNormal, localTangent);
            texNormal = matLocalTBN * texNormal;
        }

        #if defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
            float skyTexNoL = max(dot(texNormal, localLightDir), 0.0);

            #if MATERIAL_SSS != SSS_NONE
                skyTexNoL = mix(skyTexNoL, 1.0, sss);
            #endif

            shadowColor *= 1.2 * pow(skyTexNoL, 0.8);
        #endif
    #else
        shadowColor *= max(vLit, 0.0);
    #endif

    #if !defined RENDER_TRANSLUCENT && ((defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE == DYN_LIGHT_TRACED) || (defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE && defined SHADOW_BLUR))
        float dither = (InterleavedGradientNoise() - 0.5) / 255.0;

        float fogF = GetVanillaFogFactor(vLocalPos);
        vec3 fogColorFinal = GetFogColor(normalize(vLocalPos).y);
        fogColorFinal = LinearToRGB(fogColorFinal);

        color.a = 1.0;
        outDeferredColor = color;
        outDeferredShadow = vec4(shadowColor, 1.0);

        uvec4 deferredData;
        deferredData.r = packUnorm4x8(vec4(localNormal * 0.5 + 0.5, sss));
        deferredData.g = packUnorm4x8(vec4(lmcoord + dither, occlusion + dither, emission));
        deferredData.b = packUnorm4x8(vec4(fogColorFinal, fogF + dither));
        deferredData.a = packUnorm4x8(vec4(texNormal * 0.5 + 0.5, 1.0));
        outDeferredData = deferredData;

        #if MATERIAL_SPECULAR != SPECULAR_NONE
            outDeferredRough = vec4(roughness, metal_f0, 0.0, 1.0);
        #endif
    #else
        color.rgb = RGBToLinear(color.rgb);
        float roughL = max(_pow2(roughness), ROUGH_MIN);

        #ifdef RENDER_TRANSLUCENT
            if (color.a > (0.5/255.0)) {
                #if MATERIAL_NORMALS != NORMALMAP_NONE
                    float NoV = abs(dot(texNormal, localViewDir));
                #else
                    float NoV = abs(dot(localNormal, localViewDir));
                #endif

                float F = F_schlick(NoV, metal_f0, 1.0);
                color.a += (1.0 - color.a) * F;
            }
        #endif

        vec3 blockDiffuse = vBlockLight;
        vec3 blockSpecular = vec3(0.0);

        blockDiffuse += emission * DynamicLightBrightness;

        GetFinalBlockLighting(blockDiffuse, blockSpecular, vLocalPos, localNormal, texNormal, lmcoord.x, roughL, metal_f0, sss);

        vec3 skyDiffuse = vec3(0.0);
        vec3 skySpecular = vec3(0.0);

        #ifdef WORLD_SKY_ENABLED
            GetSkyLightingFinal(skyDiffuse, skySpecular, shadowColor, localViewDir, localNormal, texNormal, lmcoord.y, roughL, metal_f0, sss);
        #endif

        color.rgb = GetFinalLighting(color.rgb, blockDiffuse, blockSpecular, skyDiffuse, skySpecular, lmcoord, metal_f0, occlusion);

        ApplyFog(color, vLocalPos);

        #ifdef VL_BUFFER_ENABLED
            float farMax = min(length(vPos) - 0.05, far);
            vec4 vlScatterTransmit = GetVolumetricLighting(-localViewDir, near, farMax);
            color.rgb = color.rgb * vlScatterTransmit.a + vlScatterTransmit.rgb;
        #endif

        ApplyPostProcessing(color.rgb);
        outFinal = color;
    #endif
}
