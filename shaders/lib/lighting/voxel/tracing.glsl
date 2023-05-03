vec3 GetLightGlassTint(const in uint blockId) {
    vec3 stepTint = vec3(1.0);

    switch (blockId) {
        case BLOCK_HONEY:
            stepTint = vec3(0.984, 0.733, 0.251);
            break;
        case BLOCK_SLIME:
            stepTint = vec3(0.408, 0.725, 0.329);
            break;
        case BLOCK_SNOW:
            stepTint = vec3(0.375, 0.546, 0.621);
            break;
        case BLOCK_STAINED_GLASS_BLACK:
            stepTint = vec3(0.1, 0.1, 0.1);
            break;
        case BLOCK_STAINED_GLASS_BLUE:
            stepTint = vec3(0.1, 0.1, 0.98);
            break;
        case BLOCK_STAINED_GLASS_BROWN:
            stepTint = vec3(0.566, 0.388, 0.148);
            break;
        case BLOCK_STAINED_GLASS_CYAN:
            stepTint = vec3(0.082, 0.533, 0.763);
            break;
        case BLOCK_STAINED_GLASS_GRAY:
            stepTint = vec3(0.4, 0.4, 0.4);
            break;
        case BLOCK_STAINED_GLASS_GREEN:
            stepTint = vec3(0.125, 0.808, 0.081);
            break;
        case BLOCK_STAINED_GLASS_LIGHT_BLUE:
            stepTint = vec3(0.320, 0.685, 0.955);
            break;
        case BLOCK_STAINED_GLASS_LIGHT_GRAY:
            stepTint = vec3(0.7, 0.7, 0.7);
            break;
        case BLOCK_STAINED_GLASS_LIME:
            stepTint = vec3(0.633, 0.924, 0.124);
            break;
        case BLOCK_STAINED_GLASS_MAGENTA:
            stepTint = vec3(0.698, 0.298, 0.847);
            break;
        case BLOCK_STAINED_GLASS_ORANGE:
            stepTint = vec3(0.919, 0.586, 0.185);
            break;
        case BLOCK_STAINED_GLASS_PINK:
            stepTint = vec3(0.949, 0.274, 0.497);
            break;
        case BLOCK_STAINED_GLASS_PURPLE:
            stepTint = vec3(0.578, 0.170, 0.904);
            break;
        case BLOCK_STAINED_GLASS_RED:
            stepTint = vec3(0.999, 0.188, 0.188);
            break;
        case BLOCK_STAINED_GLASS_WHITE:
            stepTint = vec3(0.96, 0.96, 0.96);
            break;
        case BLOCK_STAINED_GLASS_YELLOW:
            stepTint = vec3(0.965, 0.965, 0.123);
            break;
    }

    return RGBToLinear(stepTint);
}

vec3 TraceDDA_fast(vec3 origin, const in vec3 endPos, const in float range) {
    vec3 traceRay = endPos - origin;
    float traceRayLen = length(traceRay);
    if (traceRayLen < EPSILON) return vec3(1.0);

    vec3 direction = traceRay / traceRayLen;
    float STEP_COUNT = 16;//ceil(traceRayLen);

    vec3 stepSizes = 1.0 / abs(direction);
    vec3 stepDir = sign(direction);
    vec3 nextDist = (stepDir * 0.5 + 0.5 - fract(origin)) / direction;

    float traceRayLen2 = _pow2(traceRayLen);
    vec3 color = vec3(1.0);
    vec3 currPos = origin;
    bool hit = false;

    for (int i = 0; i < STEP_COUNT && !hit; i++) {
        vec3 rayStart = currPos;

        float closestDist = minOf(nextDist);
        currPos += direction * closestDist;
        if (dot(currPos - origin, traceRay) > traceRayLen2) break;

        vec3 stepAxis = vec3(lessThanEqual(nextDist, vec3(closestDist)));

        nextDist -= closestDist;
        nextDist += stepSizes * stepAxis;
        
        vec3 voxelPos = floor(0.5 * (currPos + rayStart));

        ivec3 gridCell, blockCell;
        if (GetSceneLightGridCell(voxelPos, gridCell, blockCell)) {
            uint gridIndex = GetSceneLightGridIndex(gridCell);
            uint blockId = GetSceneBlockMask(blockCell, gridIndex);

            if (blockId >= BLOCK_HONEY && blockId <= BLOCK_STAINED_GLASS_YELLOW) {
                vec3 glassTint = GetLightGlassTint(blockId);
                color *= exp(-2.0 * DynamicLightTintF * closestDist * (1.0 - glassTint));
            }
            else if (blockId != BLOCK_EMPTY) {
                //vec3 rayInv = rcp(currPos - rayStart);
                hit = true;//TraceHitTest(blockId, rayStart - voxelPos, rayInv);
                color = vec3(0.0);
            }
        }
    }

    return color;
}

#define DDA_MAX_STEP ((DYN_LIGHT_RANGE/100.0) * 24)

vec3 TraceDDA(vec3 origin, const in vec3 endPos, const in float range) {
    //if (ivec3(origin) == ivec3(endPos)) return vec3(1.0);

    vec3 traceRay = endPos - origin;
    float traceRayLen = length(traceRay);
    if (traceRayLen < EPSILON) return vec3(1.0);

    vec3 direction = traceRay / traceRayLen;
    if (abs(direction.x) < EPSILON) direction.x = EPSILON;
    if (abs(direction.y) < EPSILON) direction.y = EPSILON;
    if (abs(direction.z) < EPSILON) direction.z = EPSILON;

    vec3 stepSizes = rcp(abs(direction));

    vec3 stepDir = sign(direction);
    vec3 nextDist = (stepDir * 0.5 + 0.5 - fract(origin)) / direction;

    ivec3 gridCell, blockCell;

    float traceRayLen2 = _pow2(traceRayLen);
    vec3 color = vec3(1.0);
    //vec3 currPos = origin;
    float currDist2 = 0.0;
    bool hit = false;

    #if DYN_LIGHT_TINT_MODE == LIGHT_TINT_BASIC
        uint blockIdLast;
    #endif

    float closestDist = minOf(nextDist);
    vec3 currPos = origin + direction * closestDist;

    vec3 stepAxis = vec3(lessThanEqual(nextDist, vec3(closestDist)));

    nextDist -= closestDist;
    nextDist += stepSizes * stepAxis;

    for (int i = 0; i < DDA_MAX_STEP && !hit && currDist2 < traceRayLen2; i++) {
        vec3 rayStart = currPos;

        float closestDist = minOf(nextDist);
        currPos += direction * closestDist;

        float currLen2 = length2(currPos - origin);
        if (currLen2 > traceRayLen2) currPos = endPos;
        
        vec3 voxelPos = floor(0.5 * (currPos + rayStart));

        if (ivec3(0.5 * (currPos + rayStart)) == ivec3(origin)) continue;

        vec3 stepAxis = vec3(lessThanEqual(nextDist, vec3(closestDist)));

        nextDist -= closestDist;
        nextDist += stepSizes * stepAxis;

        if (GetSceneLightGridCell(voxelPos, gridCell, blockCell)) {
            uint gridIndex = GetSceneLightGridIndex(gridCell);
            uint blockId = GetSceneBlockMask(blockCell, gridIndex);

            #ifdef DYN_LIGHT_OCTREE
                if ((SceneBlockMaps[gridIndex].OctreeMask[0] & 1u) == 0u) continue;

                uvec3 nodeMin = uvec3(0);
                uvec3 nodeMax = uvec3(LIGHT_BIN_SIZE);
                uvec3 nodePos = uvec3(0);

                bool treeHit = true;
                uint nodeBitOffset = 1u;
                for (uint treeDepth = 0u; treeDepth < DYN_LIGHT_OCTREE_LEVELS && treeHit; treeDepth++) {
                    uvec3 nodeCenter = (nodeMin + nodeMax) / 2u;
                    uvec3 nodeChild = uvec3(step(nodeCenter, blockCell));

                    uint childMask = (nodeChild.z << 2u) & (nodeChild.y << 1u) & nodeChild.x;

                    uint nodeSize = uint(exp2(treeDepth));
                    uint nodeMaskOffset = (nodePos.z * _pow2(nodeSize)) + (nodePos.y * nodeSize) + nodePos.x;

                    uint nodeBitIndex = nodeBitOffset + 8u * nodeMaskOffset + childMask;
                    uint nodeArrayIndex = nodeBitIndex / 32u;

                    uint depthMask = SceneBlockMaps[gridIndex].OctreeMask[nodeArrayIndex];
                    uint nodeMask = 1u << (nodeBitIndex - nodeArrayIndex);

                    if ((depthMask & nodeMask) == 0u) {
                        // TODO: skip
                        // vec3 nodeMin = ;
                        // vec3 nodeMax = ;
                        // for (uint ix = 0u; ix < LIGHT_BIN_SIZE; ix++) {
                        //     //
                        // }
                        treeHit = false;
                        break;
                    }

                    nodeBitOffset += uint(pow(8u, treeDepth + 1u));

                    uvec3 nodeHalfSize = (nodeMax - nodeMin) / 2u;
                    nodeMin += nodeHalfSize * nodeChild;
                    nodeMax -= nodeHalfSize * (1u - nodeChild);
                    nodePos = (nodePos + nodeChild) * 2u;
                }

                if (!treeHit) continue;
            #endif

            #if DYN_LIGHT_TINT_MODE == LIGHT_TINT_ABSORB
                if (blockId >= BLOCK_HONEY && blockId <= BLOCK_STAINED_GLASS_YELLOW) {
                    vec3 glassTint = GetLightGlassTint(blockId);
                    color *= exp(-2.0 * DynamicLightTintF * closestDist * (1.0 - glassTint));
                }
                else {
            #elif DYN_LIGHT_TINT_MODE == LIGHT_TINT_BASIC
                if (blockId >= BLOCK_HONEY && blockId <= BLOCK_STAINED_GLASS_YELLOW && blockId != blockIdLast) {
                    vec3 glassTint = GetLightGlassTint(blockId) * DynamicLightTintF;
                    glassTint += max(1.0 - DynamicLightTintF, 0.0);
                    color *= glassTint;
                }
                else {
            #endif

                if (blockId != BLOCK_EMPTY) {
                    vec3 ray = currPos - rayStart;
                    if (abs(ray.x) < EPSILON) ray.x = EPSILON;
                    if (abs(ray.y) < EPSILON) ray.y = EPSILON;
                    if (abs(ray.z) < EPSILON) ray.z = EPSILON;

                    vec3 rayInv = rcp(ray);
                    hit = TraceHitTest(blockId, rayStart - voxelPos, rayInv);
                }

            #if DYN_LIGHT_TINT_MODE != LIGHT_TINT_NONE
                }
            #endif

            #if DYN_LIGHT_TINT_MODE == LIGHT_TINT_BASIC
                blockIdLast = blockId;
            #endif
        }

        currDist2 = length2(currPos - origin);
    }

    if (hit) color = vec3(0.0);
    return color;
}

vec3 TraceRay(const in vec3 origin, const in vec3 endPos, const in float range) {
    vec3 traceRay = endPos - origin;
    float traceRayLen = length(traceRay);
    if (traceRayLen < EPSILON) return vec3(1.0);

    float dither = 0.0;
    #ifndef RENDER_COMPUTE
        dither = InterleavedGradientNoise(gl_FragCoord.xy);
    #endif

    int stepCount = int(0.5 * DYN_LIGHT_RAY_QUALITY * range);
    vec3 stepSize = traceRay / stepCount;
    vec3 color = vec3(1.0);
    bool hit = false;
    
    uint blockIdLast;
    for (int i = 1; i < stepCount && !hit; i++) {
        vec3 gridPos = (i + dither) * stepSize + origin;
        
        ivec3 gridCell, blockCell;
        if (GetSceneLightGridCell(gridPos, gridCell, blockCell)) {
            uint gridIndex = GetSceneLightGridIndex(gridCell);
            uint blockId = GetSceneBlockMask(blockCell, gridIndex);

            if (blockId >= BLOCK_HONEY && blockId <= BLOCK_STAINED_GLASS_YELLOW && blockId != blockIdLast) {
                color *= GetLightGlassTint(blockId);
            }
            else if (blockId != BLOCK_EMPTY) {
                vec3 blockPos = fract(gridPos);
                hit = TraceHitTest(blockId, blockPos, vec3(0.0));
                if (hit) color = vec3(0.0);
            }

            blockIdLast = blockId;
        }
    }

    return color;
}

#ifndef RENDER_COMPUTE
    vec3 GetLightPenumbraOffset() {
        return hash32(gl_FragCoord.xy + 0.33 * frameCounter) - 0.5;
    }
#endif
