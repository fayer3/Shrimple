#define RENDER_FINAL
#define RENDER_FRAG

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

in vec2 texcoord;

uniform sampler2D colortex0;

uniform float viewWidth;
uniform float viewHeight;

#if DEBUG_VIEW == DEBUG_VIEW_DEFERRED_COLOR
	uniform sampler2D BUFFER_DEFERRED_COLOR;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_NORMAL_GEO
	uniform usampler2D BUFFER_DEFERRED_DATA;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_LIGHTING || DEBUG_VIEW == DEBUG_VIEW_DEFERRED_LIGHTING2
	uniform usampler2D BUFFER_DEFERRED_DATA;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_SHADOW
	uniform sampler2D BUFFER_DEFERRED_SHADOW;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_FOG
	uniform usampler2D BUFFER_DEFERRED_DATA;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_NORMAL_TEX
	uniform usampler2D BUFFER_DEFERRED_DATA;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_ROUGH_METAL
	uniform sampler2D BUFFER_ROUGHNESS;
#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_VL
	uniform sampler2D BUFFER_VL;
#elif DEBUG_VIEW == DEBUG_VIEW_BLOCK_DIFFUSE
	uniform sampler2D BUFFER_BLOCK_DIFFUSE;
#elif DEBUG_VIEW == DEBUG_VIEW_BLOCK_SPECULAR
	uniform sampler2D BUFFER_BLOCK_SPECULAR;
#elif DEBUG_VIEW == DEBUG_VIEW_SHADOW_COLOR
	uniform sampler2D shadowcolor0;
#elif DEBUG_VIEW == DEBUG_VIEW_BLOOM_TILES
	uniform sampler2D BUFFER_BLOOM_TILES;
#endif

#include "/lib/sampling/bayer.glsl"
#include "/lib/sampling/ign.glsl"
#include "/lib/utility/text.glsl"
#include "/lib/utility/iris.glsl"

#if defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE != DYN_LIGHT_NONE && defined DYN_LIGHT_DEBUG_COUNTS
	#include "/lib/buffers/lighting.glsl"
#endif

#ifdef FXAA_ENABLED
	#include "/lib/post/fxaa.glsl"
#endif


void main() {
	vec2 viewSize = vec2(viewWidth, viewHeight);

	#if DEBUG_VIEW == DEBUG_VIEW_DEFERRED_COLOR
		vec3 color = texelFetch(BUFFER_DEFERRED_COLOR, ivec2(texcoord * viewSize), 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_NORMAL_GEO
		uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, ivec2(texcoord * viewSize), 0);
		vec3 color = unpackUnorm4x8(deferredData.r).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_LIGHTING
		uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, ivec2(texcoord * viewSize), 0);
		vec3 color = vec3(unpackUnorm4x8(deferredData.g).rg, 0.0);
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_LIGHTING2
		uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, ivec2(texcoord * viewSize), 0);
		vec3 color = vec3(unpackUnorm4x8(deferredData.g).ba, 0.0);
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_SHADOW
		vec3 color = texelFetch(BUFFER_DEFERRED_SHADOW, ivec2(texcoord * viewSize), 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_FOG
		uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, ivec2(texcoord * viewSize), 0);
		vec4 fog = unpackUnorm4x8(deferredData.b);
		vec3 color = fog.rgb * fog.a;
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_NORMAL_TEX
		uvec4 deferredData = texelFetch(BUFFER_DEFERRED_DATA, ivec2(texcoord * viewSize), 0);
		vec3 color = unpackUnorm4x8(deferredData.a).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_ROUGH_METAL
		vec3 color = vec3(textureLod(BUFFER_ROUGHNESS, texcoord, 0).rg, 0.0);
	#elif DEBUG_VIEW == DEBUG_VIEW_DEFERRED_VL
		vec3 color = textureLod(BUFFER_VL, texcoord, 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_BLOCK_DIFFUSE
		vec3 color = textureLod(BUFFER_BLOCK_DIFFUSE, texcoord, 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_BLOCK_SPECULAR
		vec3 color = textureLod(BUFFER_BLOCK_SPECULAR, texcoord, 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_SHADOW_COLOR
		vec3 color = textureLod(shadowcolor0, texcoord, 0).rgb;
	#elif DEBUG_VIEW == DEBUG_VIEW_BLOOM_TILES
		vec3 color = textureLod(BUFFER_BLOOM_TILES, texcoord, 0).rgb;
	#else
		#ifdef FXAA_ENABLED
			vec3 color = FXAA(texcoord);
		#else
			vec3 color = texelFetch(colortex0, ivec2(gl_FragCoord.xy), 0).rgb;
		#endif
	#endif

    //color.rgb += (GetScreenBayerValue() * 2.0 - 1.0) / 255.0;
    color.rgb += InterleavedGradientNoise(gl_FragCoord.xy) / 256.0;

	#if defined IRIS_FEATURE_SSBO && DYN_LIGHT_MODE != DYN_LIGHT_NONE && defined DYN_LIGHT_DEBUG_COUNTS
		beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(4, viewHeight/2 - 24));

		text.bgCol = vec4(0.0, 0.0, 0.0, 0.6);
		text.fgCol = vec4(1.0, 1.0, 1.0, 1.0);

		printString((_V, _i, _s, _i, _b, _l, _e, _colon, _space));
		printUnsignedInt(SceneLightCount);
		printLine();

		printString((_T, _o, _t, _a, _l, _colon, _space, _space, _space));
		printUnsignedInt(SceneLightMaxCount);
		printLine();

		printString((_S, _S, _B, _O, _colon, _space, _space, _space, _space));
		printUnsignedInt(DYN_LIGHT_SSBO_SIZE);
		printString((_m, _b));
		printLine();

		printString((_L, _i, _g, _h, _t, _colon, _space, _space, _space));
		printUnsignedInt(DYN_LIGHT_IMG_SIZE);
		printString((_x));
		printLine();

		printString((_B, _l, _o, _c, _k, _colon, _space, _space, _space));
		printUnsignedInt(DYN_LIGHT_BLOCK_IMG_SIZE);
		printString((_x));

		endText(color);
	#endif

	#if !defined IRIS_FEATURE_SSBO && (DYN_LIGHT_MODE != DYN_LIGHT_NONE || SHADOW_TYPE == SHADOW_TYPE_CASCADED)
		#ifdef IS_IRIS
			if (all(greaterThan(gl_FragCoord.xy, vec2(8.0, 8.0))) && all(lessThanEqual(gl_FragCoord.xy, vec2(620.0, 32.0))))
				color = mix(color, vec3(0.7, 0.0, 0.0), 0.7);

			beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(8, 14));
			text.bgCol = vec4(0.0);
			text.fgCol = vec4(1.0, 1.0, 1.0, 1.0);
			printString((_E, _R, _R, _O, _R, _colon, _space, _E, _n, _a, _b, _l, _e, _d, _space, _f, _e, _a, _t, _u, _r, _e, _s, _space, _r, _e, _q, _u, _i, _r, _e, _space, _I, _r, _i, _s, _space, _1, _dot, _6, _space, _o, _r, _space, _l, _a, _t, _e, _r));
			endText(color);
		#else
			drawWarning(color);
		#endif
	#endif

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0);
}
