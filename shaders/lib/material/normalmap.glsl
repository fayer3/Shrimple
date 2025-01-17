#ifdef RENDER_VERTEX
    void PrepareNormalMap() {
        vec3 viewTangent = normalize(gl_NormalMatrix * at_tangent.xyz);
        vLocalTangent = mat3(gbufferModelViewInverse) * viewTangent;

        vTangentW = at_tangent.w;
    }
#endif

#ifdef RENDER_FRAG
    vec3 GenerateNormal(const in vec2 texcoord, const in mat2 dFdXY) {
        #ifdef RENDER_ENTITIES
            vec2 texSize = textureSize(gtexture, 0);
        #else
            vec2 texSize = atlasSize;
        #endif

        vec2 tileSize = atlasBounds[1] * texSize * MATERIAL_NORMAL_SCALE;
        vec2 tilePixelSize = rcp(tileSize);

        #if MATERIAL_PARALLAX != PARALLAX_NONE
            vec2 texcoordSnapped = GetLocalCoord(texcoord);
        #else
            vec2 texcoordSnapped = vLocalCoord;
        #endif

        texcoordSnapped = floor(texcoordSnapped * tileSize) / tileSize;

        vec2 texcoordX1 = GetAtlasCoord(texcoordSnapped - vec2(tilePixelSize.x, 0.0));
        vec2 texcoordX2 = GetAtlasCoord(texcoordSnapped + vec2(tilePixelSize.x, 0.0));
        vec2 texcoordY1 = GetAtlasCoord(texcoordSnapped - vec2(0.0, tilePixelSize.y));
        vec2 texcoordY2 = GetAtlasCoord(texcoordSnapped + vec2(0.0, tilePixelSize.y));

        vec3 texColorX1 = textureGrad(gtexture, texcoordX1, dFdXY[0], dFdXY[1]).rgb;
        vec3 texColorX2 = textureGrad(gtexture, texcoordX2, dFdXY[0], dFdXY[1]).rgb;
        vec3 texColorY1 = textureGrad(gtexture, texcoordY1, dFdXY[0], dFdXY[1]).rgb;
        vec3 texColorY2 = textureGrad(gtexture, texcoordY2, dFdXY[0], dFdXY[1]).rgb;

        float texHeightX1 = luminance(texColorX1);
        float texHeightX2 = luminance(texColorX2);
        float texHeightY1 = luminance(texColorY1);
        float texHeightY2 = luminance(texColorY2);

        #if MATERIAL_NORMAL_EDGE != 0
            vec2 texcoordC = GetAtlasCoord(texcoordSnapped);
            vec3 texColorC = textureGrad(gtexture, texcoordC, dFdXY[0], dFdXY[1]).rgb;
            float texHeightC = luminance(RGBToLinear(texColorC));

            #if MATERIAL_NORMAL_EDGE == 1
                texHeightX1 = max(texHeightC, texHeightX1);
                texHeightX2 = max(texHeightC, texHeightX2);
                texHeightY1 = max(texHeightC, texHeightY1);
                texHeightY2 = max(texHeightC, texHeightY2);
            #else
                texHeightX1 = min(texHeightC, texHeightX1);
                texHeightX2 = min(texHeightC, texHeightX2);
                texHeightY1 = min(texHeightC, texHeightY1);
                texHeightY2 = min(texHeightC, texHeightY2);
            #endif
        #endif

        float dX = texHeightX2 - texHeightX1;
        float dY = texHeightY2 - texHeightY1;

        vec3 aX = vec3(1.0, 0.0, dX * MaterialNormalStrengthF);
        vec3 aY = vec3(0.0, 1.0, dY * MaterialNormalStrengthF);

        return normalize(cross(aX, aY));
    }

    vec3 GenerateRoundNormal() {
        vec2 roundTex = vLocalCoord * 2.0 - 1.0;

        vec2 edgeTex = abs(roundTex) - (1.0 - MaterialNormalRoundF);
        roundTex = max(edgeTex * rcp(MaterialNormalRoundF), 0.0) * sign(roundTex);

        return normalize(vec3(roundTex, 1.0));
    }

    bool GetMaterialNormal(const in vec2 texcoord, const in mat2 dFdXY, inout vec3 normal) {
        bool valid = false;
        #if MATERIAL_NORMALS == NORMALMAP_LABPBR
            vec2 texNormal = textureGrad(normals, texcoord, dFdXY[0], dFdXY[1]).rg;

            if (any(greaterThan(texNormal.rg, EPSILON2))) {
                normal.xy = texNormal.xy * 2.0 - 1.0;
                normal.z = sqrt(max(1.0 - dot(normal.xy, normal.xy), EPSILON));
                valid = true;
            }
        #elif MATERIAL_NORMALS == NORMALMAP_OLDPBR
            vec3 texNormal = textureGrad(normals, texcoord, dFdXY[0], dFdXY[1]).rgb;

            if (any(greaterThan(texNormal, EPSILON3))) {
                normal = normalize(texNormal * 2.0 - 1.0);
                valid = true;
            }
        #elif MATERIAL_NORMALS == NORMALMAP_GENERATED
            #if defined RENDER_ENTITIES && MATERIAL_NORMAL_ROUND > 0
                normal = GenerateRoundNormal();
            #else
                normal = GenerateNormal(texcoord, dFdXY);
            #endif
            valid = true;
        #endif

        return valid;
    }
#endif
