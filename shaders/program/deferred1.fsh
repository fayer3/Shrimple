#define RENDER_DEFERRED
#define RENDER_FRAG

#include "/lib/common.glsl"
#include "/lib/constants.glsl"

in vec2 texcoord;

uniform sampler2D depthtex0;
uniform sampler2D BUFFER_DEFERRED_LIGHTING;
uniform sampler2D BUFFER_DEFERRED_NORMAL;
uniform sampler2D BUFFER_BLOCKLIGHT;
uniform sampler2D BUFFER_LIGHT_DEPTH;
uniform sampler2D TEX_LIGHTMAP;

#if !(defined WORLD_SHADOW_ENABLED && SHADOW_TYPE != SHADOW_TYPE_NONE) && DYN_LIGHT_MODE != DYN_LIGHT_NONE
    uniform sampler2D shadowcolor0;
#endif

uniform int frameCounter;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;

#if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    uniform int heldItemId;
    uniform int heldItemId2;
    uniform int heldBlockLightValue;
    uniform int heldBlockLightValue2;
    uniform bool firstPersonCamera;
    uniform vec3 eyePosition;
#endif

#include "/lib/sampling/depth.glsl"
#include "/lib/sampling/noise.glsl"
#include "/lib/sampling/ign.glsl"

#if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #include "/lib/blocks.glsl"
    #include "/lib/items.glsl"
#endif

#if DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #include "/lib/lighting/collisions.glsl"
#endif

#if DYN_LIGHT_MODE == DYN_LIGHT_PIXEL || DYN_LIGHT_MODE == DYN_LIGHT_TRACED
    #include "/lib/buffers/lighting.glsl"
    #include "/lib/lighting/blackbody.glsl"
    #include "/lib/lighting/dynamic.glsl"
    #include "/lib/lighting/dynamic_blocks.glsl"
#endif

#include "/lib/lighting/basic.glsl"


/* RENDERTARGETS: 5,6 */
layout(location = 0) out vec4 outLight;
layout(location = 1) out vec4 outDepth;

void main() {
	vec2 viewSize = vec2(viewWidth, viewHeight);
	vec2 bufferSize = viewSize / exp2(DYN_LIGHT_RES);

	ivec2 iTex = ivec2(gl_FragCoord.xy * exp2(DYN_LIGHT_RES));
	float depth = texelFetch(depthtex0, iTex, 0).r;
	outDepth = vec4(vec3(depth), 1.0);

	if (depth < 1.0) {
		vec3 deferredLighting = texelFetch(BUFFER_DEFERRED_LIGHTING, iTex, 0).rgb;
		vec3 localNormal = texelFetch(BUFFER_DEFERRED_NORMAL, iTex, 0).rgb;

		vec3 clipPos = vec3(gl_FragCoord.xy / bufferSize, depth) * 2.0 - 1.0;
		vec3 viewPos = unproject(gbufferProjectionInverse * vec4(clipPos, 1.0));
		vec3 localPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;

        //float lightmapBlock = saturate((deferredLighting.x - (0.5/16.0)) * (16.0/15.0));

		vec3 blockLight;
			vec3 localPosPrev = localPos + cameraPosition - previousCameraPosition;
			vec3 viewPosPrev = (gbufferPreviousModelView * vec4(localPosPrev, 1.0)).xyz;
			vec3 clipPosPrev = unproject(gbufferPreviousProjection * vec4(viewPosPrev, 1.0));

			localNormal = normalize(localNormal * 2.0 - 1.0);

			blockLight = GetFinalBlockLighting(localPos, localNormal, deferredLighting.x);
	        blockLight += SampleHandLight(localPos, localNormal);
			//blockLight += lightmapBlock;

			#if DYN_LIGHT_PENUMBRA > 0
				vec2 uvPrev = clipPosPrev.xy * 0.5 + 0.5;
				if (all(greaterThanEqual(uvPrev, vec2(0.0))) && all(lessThan(uvPrev, vec2(1.0)))) {
					ivec2 iTexPrev = ivec2(uvPrev * bufferSize);
					float depthPrev = texelFetch(BUFFER_LIGHT_DEPTH, iTexPrev, 0).r;

					float linearDepth = linearizeDepthFast(depth, near, far);
					float linearDepthPrev = linearizeDepthFast(depthPrev, near, far);
					float depthWeight = 1.0 - saturate(4.0 * abs(linearDepth - linearDepthPrev));

					float mixWeight = smoothstep(0.0, 1.0, depthWeight) * 0.96;

					vec3 blockLightPrev = texelFetch(BUFFER_BLOCKLIGHT, iTexPrev, 0).rgb;
					blockLight = mix(blockLight, blockLightPrev, mixWeight);
				}
			#endif

		outLight = vec4(blockLight, 1.0);
	}
	else {
		outLight = vec4(0.0);
	}
}