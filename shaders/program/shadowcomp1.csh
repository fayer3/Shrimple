#define RENDER_SHADOWCOMP_LPV
#define RENDER_SHADOWCOMP
#define RENDER_COMPUTE

#define LPV_CHUNK_SIZE 4

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

layout (local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

const ivec3 workGroups = ivec3(16, 8, 16);

#if defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE != DYN_LIGHT_NONE && LPV_SIZE > 0
    #ifdef DYN_LIGHT_FLICKER
        uniform sampler2D noisetex;
    #endif

    #if LPV_SUN_SAMPLES > 0 && defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
        //uniform sampler2D shadowtex0;
        uniform sampler2D shadowtex1;

        uniform sampler2D shadowcolor0;

        // #ifdef SHADOW_ENABLE_HWCOMP
        //     #ifdef IRIS_FEATURE_SEPARATE_HARDWARE_SAMPLERS
        //         uniform sampler2DShadow shadowtex0HW;
        //         uniform sampler2DShadow shadowtex1HW;
        //     #else
        //         uniform sampler2DShadow shadow;
        //     #endif
        // #endif


        uniform float rainStrength;
        uniform float far;

        #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
            uniform mat4 shadowModelView;
        #endif
    #endif

    uniform int frameCounter;
    uniform vec3 cameraPosition;
    uniform vec3 previousCameraPosition;

    #ifdef DYN_LIGHT_FLICKER
        uniform float frameTimeCounter;
    #endif

    #include "/lib/blocks.glsl"
    #include "/lib/lights.glsl"

    #include "/lib/buffers/lighting.glsl"
    #include "/lib/buffers/volume.glsl"

    #ifdef DYN_LIGHT_FLICKER
        #include "/lib/lighting/blackbody.glsl"
        #include "/lib/lighting/flicker.glsl"
    #endif

    #include "/lib/lighting/voxel/lpv.glsl"
    #include "/lib/lighting/voxel/mask.glsl"
    #include "/lib/lighting/voxel/blocks.glsl"
    #include "/lib/lighting/voxel/lights.glsl"
    #include "/lib/lighting/voxel/tinting.glsl"

    #if LPV_SUN_SAMPLES > 0 && defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
        #include "/lib/buffers/scene.glsl"
        #include "/lib/buffers/shadow.glsl"

        #include "/lib/sampling/noise.glsl"
        #include "/lib/sampling/ign.glsl"

        #include "/lib/world/sky.glsl"

        #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
            #include "/lib/shadows/cascaded.glsl"
            //#include "/lib/shadows/cascaded_render.glsl"
        #else
            #include "/lib/shadows/basic.glsl"
            //#include "/lib/shadows/basic_render.glsl"
        #endif
    #endif
#endif


ivec3 GetLPVFrameOffset() {
    vec3 posNow = GetLPVPosition(vec3(0.0));
    vec3 posLast = GetLPVPosition(previousCameraPosition - cameraPosition);
    return GetLPVImgCoord(posNow) - GetLPVImgCoord(posLast);
}

ivec3 GetLPVVoxelOffset() {
    vec3 voxelCameraOffset = fract(cameraPosition / LIGHT_BIN_SIZE) * LIGHT_BIN_SIZE;
    ivec3 voxelOrigin = ivec3(voxelCameraOffset + LightGridCenter + 0.5);

    vec3 lpvCameraOffset = fract(cameraPosition);
    ivec3 lpvOrigin = ivec3(lpvCameraOffset + SceneLPVCenter + 0.5);

    return voxelOrigin - lpvOrigin;
}

vec3 GetLpvValue(const in ivec3 texCoord) {
    return (frameCounter % 2) == 0
        ? imageLoad(imgSceneLPV_2, texCoord).rgb
        : imageLoad(imgSceneLPV_1, texCoord).rgb;
}

vec3 mixNeighbours(const in ivec3 fragCoord) {
    const float FALLOFF = 0.999;

    vec3 nX1 = GetLpvValue(fragCoord + ivec3(-1,  0,  0));
    vec3 nX2 = GetLpvValue(fragCoord + ivec3( 1,  0,  0));
    vec3 nY1 = GetLpvValue(fragCoord + ivec3( 0, -1,  0));
    vec3 nY2 = GetLpvValue(fragCoord + ivec3( 0,  1,  0));
    vec3 nZ1 = GetLpvValue(fragCoord + ivec3( 0,  0, -1));
    vec3 nZ2 = GetLpvValue(fragCoord + ivec3( 0,  0,  1));

    vec3 avgColor = (nX1 + nX2 + nY1 + nY2 + nZ1 + nZ2) * (1.0/6.0);
    return FALLOFF * avgColor;
}

float GetBlockBounceF(const in uint blockId) {
    float result = 1.0;

    if (blockId <= 0) result = 0.0;

    return result;
}

float GetLpvBounceF(const in ivec3 gridBlockCell) {
    ivec3 gridCell = ivec3(floor(gridBlockCell / LIGHT_BIN_SIZE));
    uint gridIndex = GetSceneLightGridIndex(gridCell);
    ivec3 blockCell = gridBlockCell - gridCell * LIGHT_BIN_SIZE;

    uint blockId = GetSceneBlockMask(blockCell, gridIndex);
    return GetBlockBounceF(blockId);
}

void main() {
    #if defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE != DYN_LIGHT_NONE && LPV_SIZE > 0
        ivec3 chunkPos = ivec3(gl_GlobalInvocationID);

        ivec3 imgChunkPos = chunkPos * LPV_CHUNK_SIZE;
        if (any(greaterThanEqual(imgChunkPos, SceneLPVSize))) return;

        int frameIndex = frameCounter % 2;
        ivec3 imgCoordOffset = GetLPVFrameOffset();
        ivec3 voxelOffset = GetLPVVoxelOffset();

        vec3 cameraOffset = fract(cameraPosition / LIGHT_BIN_SIZE) * LIGHT_BIN_SIZE;

        #if LPV_SUN_SAMPLES > 0 && DYN_LIGHT_MODE == DYN_LIGHT_TRACED && defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
            vec3 skyLightColor = WorldSkyLightColor * (1.0 - 0.96*rainStrength);
            skyLightColor *= smoothstep(0.0, 0.1, abs(localSunDirection.y));
        #endif

        for (int z = 0; z < LPV_CHUNK_SIZE; z++) {
            for (int y = 0; y < LPV_CHUNK_SIZE; y++) {
                for (int x = 0; x < LPV_CHUNK_SIZE; x++) {
                    ivec3 iPos = ivec3(x, y, z);

                    ivec3 imgCoord = imgChunkPos + iPos;
                    if (any(greaterThanEqual(imgCoord, SceneLPVSize))) continue;

                    ivec3 voxelPos = voxelOffset + imgCoord;

                    ivec3 gridCell = ivec3(floor(voxelPos / LIGHT_BIN_SIZE));
                    uint gridIndex = GetSceneLightGridIndex(gridCell);
                    ivec3 blockCell = voxelPos - gridCell * LIGHT_BIN_SIZE;
                    uint blockId = GetSceneBlockMask(blockCell, gridIndex);

                    vec3 lightValue = vec3(0.0);

                    vec3 blockLocalPos = gridCell * LIGHT_BIN_SIZE + blockCell + 0.5 - LightGridCenter - cameraOffset;

                    #if DYN_LIGHT_MODE != DYN_LIGHT_TRACED
                        uint lightType = GetSceneLightType(int(blockId));
                        if (lightType != LIGHT_NONE && lightType != LIGHT_IGNORED) {
                            StaticLightData lightInfo = StaticLightMap[lightType];
                            vec3 lightColor = unpackUnorm4x8(lightInfo.Color).rgb;
                            vec2 lightRangeSize = unpackUnorm4x8(lightInfo.RangeSize).xy;
                            float lightRange = lightRangeSize.x * 255.0;

                            lightColor = RGBToLinear(lightColor);

                            vec2 lightNoise = vec2(0.0);
                            #ifdef DYN_LIGHT_FLICKER
                                lightNoise = GetDynLightNoise(cameraPosition + blockLocalPos);
                                ApplyLightFlicker(lightColor, lightType, lightNoise);
                            #endif

                            lightValue = LpvRangeF * lightColor * exp2(lightRange);
                        }
                        else {
                    #endif
                        bool allowLight = false;
                        vec3 tint = vec3(1.0);

                        #ifdef LPV_GLASS_TINT
                            if (blockId >= BLOCK_HONEY && blockId <= BLOCK_STAINED_GLASS_YELLOW) {
                                tint = GetLightGlassTint(blockId);
                                allowLight = true;
                            }
                            else {
                        #endif
                            allowLight = IsTraceOpenBlock(blockId);
                        #ifdef LPV_GLASS_TINT
                            }
                        #endif

                        if (allowLight) {
                            ivec3 imgCoordPrev = imgCoord + imgCoordOffset;
                            lightValue = mixNeighbours(imgCoordPrev) * tint;

                            #if LPV_SUN_SAMPLES > 0 && DYN_LIGHT_MODE == DYN_LIGHT_TRACED && defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
                                float bounceF = (1.0/6.0) * (
                                    GetLpvBounceF(voxelPos + ivec3( 1, 0, 0)) +
                                    GetLpvBounceF(voxelPos + ivec3(-1, 0, 0)) +
                                    GetLpvBounceF(voxelPos + ivec3( 0, 1, 0)) +
                                    GetLpvBounceF(voxelPos + ivec3( 0,-1, 0)) +
                                    GetLpvBounceF(voxelPos + ivec3( 0, 0, 1)) +
                                    GetLpvBounceF(voxelPos + ivec3( 0, 0,-1))
                                );

                                #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
                                    vec3 shadowPos = (shadowModelView * vec4(blockLocalPos, 1.0)).xyz;
                                    int cascade = GetShadowCascade(shadowPos, -1.5);

                                    float shadowBias = GetShadowOffsetBias(cascade);
                                #else
                                    float shadowBias = GetShadowOffsetBias();
                                #endif

                                vec3 shadowF = vec3(0.0);

                                for (uint i = 0; i < LPV_SUN_SAMPLES; i++) {
                                    //float ign = InterleavedGradientNoise(imgCoord.xz + 3.0*imgCoord.y);
                                    vec3 shadowOffset = hash44(vec4(cameraPosition + blockLocalPos, i)).xyz;
                                    vec3 blockLpvPos = blockLocalPos + 0.8*(shadowOffset - 0.5);

                                    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
                                        vec3 shadowPos = (shadowModelView * vec4(blockLpvPos, 1.0)).xyz;
                                        //int cascade = GetShadowCascade(shadowPos, 0.0);
                                        shadowPos = (cascadeProjection[cascade] * vec4(shadowPos, 1.0)).xyz;

                                        shadowPos = shadowPos * 0.5 + 0.5;
                                        shadowPos.xy = shadowPos.xy * 0.5 + shadowProjectionPos[cascade];
                                        //shadowPos.xy = shadowPos.xy * 2.0 - 1.0;
                                    #else
                                        vec3 shadowPos = (shadowModelViewProjection * vec4(blockLpvPos, 1.0)).xyz;

                                        shadowPos = distort(shadowPos);
                                        shadowPos = shadowPos * 0.5 + 0.5;
                                    #endif

                                    vec3 shadowSample = textureLod(shadowcolor0, shadowPos.xy, 0).rgb;
                                    shadowSample = RGBToLinear(shadowSample);

                                    float texDepth = texture(shadowtex1, shadowPos.xy).r;
                                    float shadowDist = max(texDepth - shadowPos.z, 0.0);
                                    shadowSample *= step(shadowBias, shadowDist) * max(1.0 - (shadowDist * far / 8.0), 0.0);

                                    shadowF += shadowSample;
                                }

                                shadowF *= rcp(LPV_SUN_SAMPLES) * bounceF;

                                //float shadowF = CompareDepth(shadowPos, vec2(0.0), shadowBias);

                                //float horizonF = GetSkyHorizonF(sunDir.y);
                                lightValue += mix(24.0, 2048.0, max(localSunDirection.y, 0.0)) * skyLightColor * shadowF;
                                //lightValue += 1024.0 * WorldSkyLightColor * shadowF * bounceF;
                            #endif
                        }
                    #if DYN_LIGHT_MODE != DYN_LIGHT_TRACED
                        }
                    #endif

                    if (frameIndex == 0)
                        imageStore(imgSceneLPV_1, imgCoord, vec4(lightValue, 1.0));
                    else
                        imageStore(imgSceneLPV_2, imgCoord, vec4(lightValue, 1.0));
                }
            }
        }
    #endif
}
