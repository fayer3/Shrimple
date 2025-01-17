#define RENDER_PARTICLES
#define RENDER_GBUFFER
#define RENDER_VERTEX

#define RENDER_BILLBOARD

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

#ifdef MATERIAL_PARTICLES
    in vec4 at_tangent;
    in vec4 mc_midTexCoord;
#endif

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
out vec3 vPos;
out vec3 vNormal;
out float geoNoL;
out vec3 vBlockLight;
out vec3 vLocalPos;
out vec3 vLocalNormal;

#ifdef MATERIAL_PARTICLES
    out vec2 vLocalCoord;
    out vec3 vLocalTangent;
    out float vTangentW;

    flat out mat2 atlasBounds;
#endif

#ifdef WORLD_SHADOW_ENABLED
    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
        out vec3 shadowPos[4];
        flat out int shadowTile;
    #elif SHADOW_TYPE != SHADOW_TYPE_NONE
        out vec3 shadowPos;
    #endif
#endif

uniform sampler2D lightmap;
//uniform sampler2D noisetex;

//uniform float frameTimeCounter;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

#ifdef WORLD_SHADOW_ENABLED
    uniform mat4 shadowModelView;
    uniform mat4 shadowProjection;
    uniform vec3 shadowLightPosition;
    uniform float far;

    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
        attribute vec3 at_midBlock;

        uniform mat4 gbufferProjection;
        uniform float near;
    #endif
#endif

#ifdef IRIS_FEATURE_SSBO
    #include "/lib/buffers/scene.glsl"
#endif

#if defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE
    #include "/lib/utility/matrix.glsl"
    #include "/lib/buffers/shadow.glsl"
    #include "/lib/shadows/common.glsl"

    #if SHADOW_TYPE == SHADOW_TYPE_CASCADED
        #include "/lib/shadows/cascaded.glsl"
    #else
        #include "/lib/shadows/basic.glsl"
    #endif
#endif

#ifdef MATERIAL_PARTICLES
    #include "/lib/sampling/atlas.glsl"
    #include "/lib/utility/tbn.glsl"

    #include "/lib/material/normalmap.glsl"
#endif

// #ifdef DYN_LIGHT_FLICKER
//     #include "/lib/lighting/blackbody.glsl"
//     #include "/lib/lighting/flicker.glsl"
// #endif

//#include "/lib/lighting/fresnel.glsl"
//#include "/lib/lighting/sampling.glsl"

#include "/lib/lighting/basic.glsl"


void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;

    BasicVertex();

    #ifdef MATERIAL_PARTICLES
        PrepareNormalMap();

        GetAtlasBounds(atlasBounds, vLocalCoord);
    #endif
}
