#define LIGHT_NONE 0u
#define LIGHT_BLOCK_1 1u
#define LIGHT_BLOCK_2 2u
#define LIGHT_BLOCK_3 3u
#define LIGHT_BLOCK_4 4u
#define LIGHT_BLOCK_5 5u
#define LIGHT_BLOCK_6 6u
#define LIGHT_BLOCK_7 7u
#define LIGHT_BLOCK_8 8u
#define LIGHT_BLOCK_9 9u
#define LIGHT_BLOCK_10 10u
#define LIGHT_BLOCK_11 11u
#define LIGHT_BLOCK_12 12u
#define LIGHT_BLOCK_13 13u
#define LIGHT_BLOCK_14 14u
#define LIGHT_BLOCK_15 15u
#define LIGHT_AMETHYST_BLOCK 16u
#define LIGHT_AMETHYST_BUD_LARGE 17u
#define LIGHT_AMETHYST_BUD_MEDIUM 18u
#define LIGHT_AMETHYST_CLUSTER 19u
#define LIGHT_BEACON 20u
#define LIGHT_BLAST_FURNACE_N 21u
#define LIGHT_BLAST_FURNACE_E 22u
#define LIGHT_BLAST_FURNACE_S 23u
#define LIGHT_BLAST_FURNACE_W 24u
#define LIGHT_BREWING_STAND 25u
#define LIGHT_CANDLES_1 26u
#define LIGHT_CANDLES_2 27u
#define LIGHT_CANDLES_3 28u
#define LIGHT_CANDLES_4 29u
#define LIGHT_CANDLE_CAKE 30u
#define LIGHT_CAVEVINE_BERRIES 31u
#define LIGHT_COMPARATOR 32u
#define LIGHT_CRYING_OBSIDIAN 33u
#define LIGHT_DIAMOND_BLOCK 34u
#define LIGHT_EMERALD_BLOCK 35u
#define LIGHT_END_ROD 36u
#define LIGHT_CAMPFIRE 37u
#define LIGHT_FIRE 38u
#define LIGHT_FURNACE_N 39u
#define LIGHT_FURNACE_E 40u
#define LIGHT_FURNACE_S 41u
#define LIGHT_FURNACE_W 42u
#define LIGHT_GLOWSTONE 43u
#define LIGHT_GLOW_LICHEN 44u
#define LIGHT_JACK_O_LANTERN_N 45u
#define LIGHT_JACK_O_LANTERN_E 46u
#define LIGHT_JACK_O_LANTERN_S 47u
#define LIGHT_JACK_O_LANTERN_W 48u
#define LIGHT_LANTERN 49u
#define LIGHT_LAPIS_BLOCK 50u
#define LIGHT_LIGHTING_ROD 51u
#define LIGHT_LAVA 52u
#define LIGHT_LAVA_CAULDRON 53u
#define LIGHT_MAGMA 54u
#define LIGHT_NETHER_PORTAL 55u
#define LIGHT_FROGLIGHT_OCHRE 56u
#define LIGHT_FROGLIGHT_PEARLESCENT 57u
#define LIGHT_FROGLIGHT_VERDANT 58u
#define LIGHT_RAIL_POWERED 59u
#define LIGHT_REDSTONE_BLOCK 60u
#define LIGHT_REDSTONE_LAMP 61u
#define LIGHT_REDSTONE_TORCH 62u
#define LIGHT_REDSTONE_WIRE_1 63u
#define LIGHT_REDSTONE_WIRE_2 64u
#define LIGHT_REDSTONE_WIRE_3 65u
#define LIGHT_REDSTONE_WIRE_4 66u
#define LIGHT_REDSTONE_WIRE_5 67u
#define LIGHT_REDSTONE_WIRE_6 68u
#define LIGHT_REDSTONE_WIRE_7 69u
#define LIGHT_REDSTONE_WIRE_8 70u
#define LIGHT_REDSTONE_WIRE_9 71u
#define LIGHT_REDSTONE_WIRE_10 72u
#define LIGHT_REDSTONE_WIRE_11 73u
#define LIGHT_REDSTONE_WIRE_12 74u
#define LIGHT_REDSTONE_WIRE_13 75u
#define LIGHT_REDSTONE_WIRE_14 76u
#define LIGHT_REDSTONE_WIRE_15 77u
#define LIGHT_REPEATER 78u
#define LIGHT_RESPAWN_ANCHOR_1 79u
#define LIGHT_RESPAWN_ANCHOR_2 80u
#define LIGHT_RESPAWN_ANCHOR_3 81u
#define LIGHT_RESPAWN_ANCHOR_4 82u
#define LIGHT_SCULK_CATALYST 83u
#define LIGHT_SEA_LANTERN 84u
#define LIGHT_SEA_PICKLE_1 85u
#define LIGHT_SEA_PICKLE_2 86u
#define LIGHT_SEA_PICKLE_3 87u
#define LIGHT_SEA_PICKLE_4 88u
#define LIGHT_SHROOMLIGHT 89u
#define LIGHT_SMOKER_N 90u
#define LIGHT_SMOKER_E 91u
#define LIGHT_SMOKER_S 92u
#define LIGHT_SMOKER_W 93u
#define LIGHT_SOUL_LANTERN 94u
#define LIGHT_SOUL_TORCH 95u
#define LIGHT_SOUL_CAMPFIRE 96u
#define LIGHT_SOUL_FIRE 97u
#define LIGHT_TORCH 98u

#define LIGHT_CONCRETE_BLUE 100u
#define LIGHT_CONCRETE_GREEN 101u
#define LIGHT_CONCRETE_RED 102u

#define LIGHT_IGNORED 255u


uint GetSceneLightType(const in int blockId) {
    uint lightType = LIGHT_NONE;
    if (blockId < 1) return lightType;

    switch (blockId) {
        case BLOCK_LIGHT_1:
            lightType = LIGHT_BLOCK_1;
            break;
        case BLOCK_LIGHT_2:
            lightType = LIGHT_BLOCK_2;
            break;
        case BLOCK_LIGHT_3:
            lightType = LIGHT_BLOCK_3;
            break;
        case BLOCK_LIGHT_4:
            lightType = LIGHT_BLOCK_4;
            break;
        case BLOCK_LIGHT_5:
            lightType = LIGHT_BLOCK_5;
            break;
        case BLOCK_LIGHT_6:
            lightType = LIGHT_BLOCK_6;
            break;
        case BLOCK_LIGHT_7:
            lightType = LIGHT_BLOCK_7;
            break;
        case BLOCK_LIGHT_8:
            lightType = LIGHT_BLOCK_8;
            break;
        case BLOCK_LIGHT_9:
            lightType = LIGHT_BLOCK_9;
            break;
        case BLOCK_LIGHT_10:
            lightType = LIGHT_BLOCK_10;
            break;
        case BLOCK_LIGHT_11:
            lightType = LIGHT_BLOCK_11;
            break;
        case BLOCK_LIGHT_12:
            lightType = LIGHT_BLOCK_12;
            break;
        case BLOCK_LIGHT_13:
            lightType = LIGHT_BLOCK_13;
            break;
        case BLOCK_LIGHT_14:
            lightType = LIGHT_BLOCK_14;
            break;
        case BLOCK_LIGHT_15:
            lightType = LIGHT_BLOCK_15;
            break;

        case BLOCK_AMETHYST:
            lightType = LIGHT_AMETHYST_BLOCK;
            break;
        case BLOCK_AMETHYST_BUD_LARGE:
            lightType = LIGHT_AMETHYST_BUD_LARGE;
            break;
        case BLOCK_AMETHYST_BUD_MEDIUM:
            lightType = LIGHT_AMETHYST_BUD_MEDIUM;
            break;
        case BLOCK_AMETHYST_CLUSTER:
            lightType = LIGHT_AMETHYST_CLUSTER;
            break;
        case BLOCK_BEACON:
            lightType = LIGHT_BEACON;
            break;
        case BLOCK_BLAST_FURNACE_LIT_N:
            lightType = LIGHT_BLAST_FURNACE_N;
            break;
        case BLOCK_BLAST_FURNACE_LIT_E:
            lightType = LIGHT_BLAST_FURNACE_E;
            break;
        case BLOCK_BLAST_FURNACE_LIT_S:
            lightType = LIGHT_BLAST_FURNACE_S;
            break;
        case BLOCK_BLAST_FURNACE_LIT_W:
            lightType = LIGHT_BLAST_FURNACE_W;
            break;
        case BLOCK_BREWING_STAND:
            lightType = LIGHT_BREWING_STAND;
            break;
        case BLOCK_CANDLE_CAKE_LIT:
            lightType = LIGHT_CANDLE_CAKE;
            break;
        case BLOCK_CANDLES_LIT_1:
            lightType = LIGHT_CANDLES_1;
            break;
        case BLOCK_CANDLES_LIT_2:
            lightType = LIGHT_CANDLES_2;
            break;
        case BLOCK_CANDLES_LIT_3:
            lightType = LIGHT_CANDLES_3;
            break;
        case BLOCK_CANDLES_LIT_4:
            lightType = LIGHT_CANDLES_4;
            break;
        case BLOCK_CRYING_OBSIDIAN:
            lightType = LIGHT_CRYING_OBSIDIAN;
            break;
        case BLOCK_END_ROD:
            lightType = LIGHT_END_ROD;
            break;
        case BLOCK_CAMPFIRE_LIT:
            lightType = LIGHT_CAMPFIRE;
            break;
        case BLOCK_FIRE:
            lightType = LIGHT_FIRE;
            break;
        case BLOCK_FROGLIGHT_OCHRE:
            lightType = LIGHT_FROGLIGHT_OCHRE;
            break;
        case BLOCK_FROGLIGHT_PEARLESCENT:
            lightType = LIGHT_FROGLIGHT_PEARLESCENT;
            break;
        case BLOCK_FROGLIGHT_VERDANT:
            lightType = LIGHT_FROGLIGHT_VERDANT;
            break;
        case BLOCK_FURNACE_LIT_N:
            lightType = LIGHT_FURNACE_N;
            break;
        case BLOCK_FURNACE_LIT_E:
            lightType = LIGHT_FURNACE_E;
            break;
        case BLOCK_FURNACE_LIT_S:
            lightType = LIGHT_FURNACE_S;
            break;
        case BLOCK_FURNACE_LIT_W:
            lightType = LIGHT_FURNACE_W;
            break;
        case BLOCK_GLOWSTONE:
            lightType = LIGHT_GLOWSTONE;
            break;
        case BLOCK_GLOW_LICHEN:
            lightType = LIGHT_GLOW_LICHEN;
            break;
        case BLOCK_JACK_O_LANTERN_N:
            lightType = LIGHT_JACK_O_LANTERN_N;
            break;
        case BLOCK_JACK_O_LANTERN_E:
            lightType = LIGHT_JACK_O_LANTERN_E;
            break;
        case BLOCK_JACK_O_LANTERN_S:
            lightType = LIGHT_JACK_O_LANTERN_S;
            break;
        case BLOCK_JACK_O_LANTERN_W:
            lightType = LIGHT_JACK_O_LANTERN_W;
            break;
        case BLOCK_LANTERN_CEIL:
        case BLOCK_LANTERN_FLOOR:
            lightType = LIGHT_LANTERN;
            break;
        case BLOCK_LIGHTING_ROD_POWERED:
            lightType = LIGHT_LIGHTING_ROD;
            break;
        case BLOCK_LAVA_CAULDRON:
            lightType = LIGHT_LAVA_CAULDRON;
            break;
        case BLOCK_MAGMA:
            lightType = LIGHT_MAGMA;
            break;
        case BLOCK_REDSTONE_LAMP_LIT:
            lightType = LIGHT_REDSTONE_LAMP;
            break;
        case BLOCK_REDSTONE_TORCH_LIT:
            lightType = LIGHT_REDSTONE_TORCH;
            break;
        case BLOCK_RESPAWN_ANCHOR_1:
            lightType = LIGHT_RESPAWN_ANCHOR_1;
            break;
        case BLOCK_RESPAWN_ANCHOR_2:
            lightType = LIGHT_RESPAWN_ANCHOR_2;
            break;
        case BLOCK_RESPAWN_ANCHOR_3:
            lightType = LIGHT_RESPAWN_ANCHOR_3;
            break;
        case BLOCK_RESPAWN_ANCHOR_4:
            lightType = LIGHT_RESPAWN_ANCHOR_4;
            break;
        case BLOCK_SCULK_CATALYST:
            lightType = LIGHT_SCULK_CATALYST;
            break;
        case BLOCK_SEA_LANTERN:
            lightType = LIGHT_SEA_LANTERN;
            break;
        case BLOCK_SEA_PICKLE_WET_1:
            lightType = LIGHT_SEA_PICKLE_1;
            break;
        case BLOCK_SEA_PICKLE_WET_2:
            lightType = LIGHT_SEA_PICKLE_2;
            break;
        case BLOCK_SEA_PICKLE_WET_3:
            lightType = LIGHT_SEA_PICKLE_3;
            break;
        case BLOCK_SEA_PICKLE_WET_4:
            lightType = LIGHT_SEA_PICKLE_4;
            break;
        case BLOCK_SHROOMLIGHT:
            lightType = LIGHT_SHROOMLIGHT;
            break;
        case BLOCK_SMOKER_LIT_N:
            lightType = LIGHT_SMOKER_N;
            break;
        case BLOCK_SMOKER_LIT_E:
            lightType = LIGHT_SMOKER_E;
            break;
        case BLOCK_SMOKER_LIT_S:
            lightType = LIGHT_SMOKER_S;
            break;
        case BLOCK_SMOKER_LIT_W:
            lightType = LIGHT_SMOKER_W;
            break;
        case BLOCK_SOUL_CAMPFIRE_LIT:
            lightType = LIGHT_SOUL_CAMPFIRE;
            break;
        case BLOCK_SOUL_FIRE:
            lightType = LIGHT_SOUL_FIRE;
            break;
        case BLOCK_SOUL_LANTERN_CEIL:
        case BLOCK_SOUL_LANTERN_FLOOR:
            lightType = LIGHT_SOUL_LANTERN;
            break;
        case BLOCK_SOUL_TORCH:
        case BLOCK_SOUL_TORCH_WALL:
            lightType = LIGHT_SOUL_TORCH;
            break;
        case BLOCK_TORCH:
        case BLOCK_TORCH_WALL:
            lightType = LIGHT_TORCH;
            break;
    }

    #if DYN_LIGHT_GLOW_BERRIES != DYN_LIGHT_BLOCK_NONE
        if (blockId == BLOCK_CAVEVINE_BERRIES) lightType = LIGHT_CAVEVINE_BERRIES;
    #endif

    #if DYN_LIGHT_LAVA != DYN_LIGHT_BLOCK_NONE
        if (blockId == BLOCK_LAVA) lightType = LIGHT_LAVA;
    #endif

    #if DYN_LIGHT_PORTAL != DYN_LIGHT_BLOCK_NONE
        if (blockId == BLOCK_NETHER_PORTAL) lightType = LIGHT_NETHER_PORTAL;
    #endif

    #if DYN_LIGHT_REDSTONE != DYN_LIGHT_BLOCK_NONE
        switch (blockId) {
            case BLOCK_COMPARATOR_LIT:
                lightType = LIGHT_COMPARATOR;
                break;
            case BLOCK_RAIL_POWERED:
                lightType = LIGHT_RAIL_POWERED;
                break;
            case BLOCK_REDSTONE_WIRE_1:
                lightType = LIGHT_REDSTONE_WIRE_1;
                break;
            case BLOCK_REDSTONE_WIRE_2:
                lightType = LIGHT_REDSTONE_WIRE_2;
                break;
            case BLOCK_REDSTONE_WIRE_3:
                lightType = LIGHT_REDSTONE_WIRE_3;
                break;
            case BLOCK_REDSTONE_WIRE_4:
                lightType = LIGHT_REDSTONE_WIRE_4;
                break;
            case BLOCK_REDSTONE_WIRE_5:
                lightType = LIGHT_REDSTONE_WIRE_5;
                break;
            case BLOCK_REDSTONE_WIRE_6:
                lightType = LIGHT_REDSTONE_WIRE_6;
                break;
            case BLOCK_REDSTONE_WIRE_7:
                lightType = LIGHT_REDSTONE_WIRE_7;
                break;
            case BLOCK_REDSTONE_WIRE_8:
                lightType = LIGHT_REDSTONE_WIRE_8;
                break;
            case BLOCK_REDSTONE_WIRE_9:
                lightType = LIGHT_REDSTONE_WIRE_9;
                break;
            case BLOCK_REDSTONE_WIRE_10:
                lightType = LIGHT_REDSTONE_WIRE_10;
                break;
            case BLOCK_REDSTONE_WIRE_11:
                lightType = LIGHT_REDSTONE_WIRE_11;
                break;
            case BLOCK_REDSTONE_WIRE_12:
                lightType = LIGHT_REDSTONE_WIRE_12;
                break;
            case BLOCK_REDSTONE_WIRE_13:
                lightType = LIGHT_REDSTONE_WIRE_13;
                break;
            case BLOCK_REDSTONE_WIRE_14:
                lightType = LIGHT_REDSTONE_WIRE_14;
                break;
            case BLOCK_REDSTONE_WIRE_15:
                lightType = LIGHT_REDSTONE_WIRE_15;
                break;
            case BLOCK_REPEATER_LIT:
                lightType = LIGHT_REPEATER;
                break;
        }
    #endif

    #ifdef DYN_LIGHT_CONCRETE
        switch (blockId) {
            case BLOCK_CONCRETE_BLUE:
                lightType = LIGHT_CONCRETE_BLUE;
                break;
            case BLOCK_CONCRETE_GREEN:
                lightType = LIGHT_CONCRETE_GREEN;
                break;
            case BLOCK_CONCRETE_RED:
                lightType = LIGHT_CONCRETE_RED;
                break;
        }
    #endif

    #ifdef DYN_LIGHT_OREBLOCKS
        switch (blockId) {
            case BLOCK_DIAMOND:
                lightType = LIGHT_DIAMOND_BLOCK;
                break;
            case BLOCK_EMERALD:
                lightType = LIGHT_EMERALD_BLOCK;
                break;
            case BLOCK_LAPIS:
                lightType = LIGHT_LAPIS_BLOCK;
                break;
            case BLOCK_REDSTONE:
                lightType = LIGHT_REDSTONE_BLOCK;
                break;
        }
    #endif

    return lightType;
}

#if !(defined RENDER_SHADOW || defined RENDER_SHADOWCOMP_LIGHT_NEIGHBORS)
    vec3 GetSceneLightColor(const in uint lightType, const in vec2 noiseSample) {
        vec3 lightColor = vec3(0.0);

        switch (lightType) {
            case LIGHT_BLOCK_1:
            case LIGHT_BLOCK_2:
            case LIGHT_BLOCK_3:
            case LIGHT_BLOCK_4:
            case LIGHT_BLOCK_5:
            case LIGHT_BLOCK_6:
            case LIGHT_BLOCK_7:
            case LIGHT_BLOCK_8:
            case LIGHT_BLOCK_9:
            case LIGHT_BLOCK_10:
            case LIGHT_BLOCK_11:
            case LIGHT_BLOCK_12:
            case LIGHT_BLOCK_13:
            case LIGHT_BLOCK_14:
            case LIGHT_BLOCK_15:
                lightColor = vec3(0.9);
                break;
            case LIGHT_AMETHYST_BUD_LARGE:
            case LIGHT_AMETHYST_BUD_MEDIUM:
            case LIGHT_AMETHYST_CLUSTER:
                lightColor = vec3(0.600, 0.439, 0.820);
                break;
            case LIGHT_BEACON:
                lightColor = vec3(1.0);
                break;
            case LIGHT_BLAST_FURNACE_N:
            case LIGHT_BLAST_FURNACE_E:
            case LIGHT_BLAST_FURNACE_S:
            case LIGHT_BLAST_FURNACE_W:
                lightColor = vec3(0.697, 0.654, 0.458);
                break;
            case LIGHT_BREWING_STAND:
                lightColor = vec3(0.636, 0.509, 0.179);
                break;
            case LIGHT_CANDLES_1:
            case LIGHT_CANDLES_2:
            case LIGHT_CANDLES_3:
            case LIGHT_CANDLES_4:
            case LIGHT_CANDLE_CAKE:
                lightColor = vec3(0.758, 0.553, 0.239);
                break;
            case LIGHT_CAVEVINE_BERRIES:
                lightColor = 0.4 * vec3(0.717, 0.541, 0.188);
                break;
            case LIGHT_CRYING_OBSIDIAN:
                lightColor = vec3(0.390, 0.065, 0.646);
                break;
            case LIGHT_END_ROD:
                lightColor = vec3(0.957, 0.929, 0.875);
                break;
            case LIGHT_CAMPFIRE:
            case LIGHT_FIRE:
                lightColor = vec3(0.851, 0.616, 0.239);
                break;
            case LIGHT_FROGLIGHT_OCHRE:
                lightColor = vec3(0.768, 0.648, 0.108);
                break;
            case LIGHT_FROGLIGHT_PEARLESCENT:
                lightColor = vec3(0.737, 0.435, 0.658);
                break;
            case LIGHT_FROGLIGHT_VERDANT:
                lightColor = vec3(0.463, 0.763, 0.409);
                break;
            case LIGHT_FURNACE_N:
            case LIGHT_FURNACE_E:
            case LIGHT_FURNACE_S:
            case LIGHT_FURNACE_W:
                lightColor = vec3(0.697, 0.654, 0.458);
                break;
            case LIGHT_GLOWSTONE:
                lightColor = vec3(0.652, 0.583, 0.275);
                break;
            case LIGHT_GLOW_LICHEN:
                lightColor = 0.8*vec3(0.173, 0.374, 0.252);
                break;
            case LIGHT_JACK_O_LANTERN_N:
            case LIGHT_JACK_O_LANTERN_E:
            case LIGHT_JACK_O_LANTERN_S:
            case LIGHT_JACK_O_LANTERN_W:
                lightColor = vec3(0.768, 0.701, 0.325);
                break;
            case LIGHT_LANTERN:
                lightColor = vec3(0.906, 0.737, 0.451);
                break;
            case LIGHT_LIGHTING_ROD:
                lightColor = vec3(0.870, 0.956, 0.975);
                break;
            case LIGHT_LAVA:
            case LIGHT_LAVA_CAULDRON:
                lightColor = vec3(0.804, 0.424, 0.149);
                break;
            case LIGHT_MAGMA:
                lightColor = vec3(0.747, 0.323, 0.110);
                break;
            case LIGHT_NETHER_PORTAL:
                lightColor = vec3(0.502, 0.165, 0.831);
                break;
            case LIGHT_REDSTONE_LAMP:
                lightColor = vec3(0.953, 0.796, 0.496);
                break;
            case LIGHT_REDSTONE_TORCH:
                lightColor = vec3(0.697, 0.130, 0.051);
                break;
            case LIGHT_COMPARATOR:
            case LIGHT_REPEATER:
            case LIGHT_REDSTONE_WIRE_1:
            case LIGHT_REDSTONE_WIRE_2:
            case LIGHT_REDSTONE_WIRE_3:
            case LIGHT_REDSTONE_WIRE_4:
            case LIGHT_REDSTONE_WIRE_5:
            case LIGHT_REDSTONE_WIRE_6:
            case LIGHT_REDSTONE_WIRE_7:
            case LIGHT_REDSTONE_WIRE_8:
            case LIGHT_REDSTONE_WIRE_9:
            case LIGHT_REDSTONE_WIRE_10:
            case LIGHT_REDSTONE_WIRE_11:
            case LIGHT_REDSTONE_WIRE_12:
            case LIGHT_REDSTONE_WIRE_13:
            case LIGHT_REDSTONE_WIRE_14:
            case LIGHT_REDSTONE_WIRE_15:
            case LIGHT_RAIL_POWERED:
                lightColor = vec3(0.697, 0.130, 0.051);
                break;
            case LIGHT_RESPAWN_ANCHOR_4:
            case LIGHT_RESPAWN_ANCHOR_3:
            case LIGHT_RESPAWN_ANCHOR_2:
            case LIGHT_RESPAWN_ANCHOR_1:
                lightColor = vec3(0.390, 0.065, 0.646);
                break;
            case LIGHT_SCULK_CATALYST:
                lightColor = vec3(0.510, 0.831, 0.851);
                break;
            case LIGHT_SEA_LANTERN:
                lightColor = vec3(0.498, 0.894, 0.834);
                break;
            case LIGHT_SEA_PICKLE_1:
            case LIGHT_SEA_PICKLE_2:
            case LIGHT_SEA_PICKLE_3:
            case LIGHT_SEA_PICKLE_4:
                lightColor = vec3(0.283, 0.394, 0.212);
                break;
            case LIGHT_SHROOMLIGHT:
                lightColor = vec3(0.848, 0.469, 0.205);
                break;
            case LIGHT_SMOKER_N:
            case LIGHT_SMOKER_E:
            case LIGHT_SMOKER_S:
            case LIGHT_SMOKER_W:
                lightColor = vec3(0.697, 0.654, 0.458);
                break;
            case LIGHT_SOUL_LANTERN:
            case LIGHT_SOUL_TORCH:
            case LIGHT_SOUL_CAMPFIRE:
            case LIGHT_SOUL_FIRE:
                lightColor = vec3(0.203, 0.725, 0.758);
                break;
            case LIGHT_TORCH:
                lightColor = vec3(0.768, 0.701, 0.325);
                break;
        }

        #ifdef DYN_LIGHT_OREBLOCKS
            switch (lightType) {
                case LIGHT_AMETHYST_BLOCK:
                    lightColor = vec3(0.600, 0.439, 0.820);
                    break;
                case LIGHT_DIAMOND_BLOCK:
                    lightColor = vec3(0.489, 0.960, 0.912);
                    break;
                case LIGHT_EMERALD_BLOCK:
                    lightColor = vec3(0.235, 0.859, 0.435);
                    break;
                case LIGHT_LAPIS_BLOCK:
                    lightColor = vec3(0.180, 0.427, 0.813);
                    break;
                case LIGHT_REDSTONE_BLOCK:
                    lightColor = vec3(0.980, 0.143, 0.026);
                    break;
            }
        #endif

        #ifdef DYN_LIGHT_CONCRETE
            switch (lightType) {
                case LIGHT_CONCRETE_BLUE:
                    lightColor = vec3(0.222, 0.235, 0.828);
                    break;
                case LIGHT_CONCRETE_GREEN:
                    lightColor = vec3(0.574, 0.753, 0.207);
                    break;
                case LIGHT_CONCRETE_RED:
                    lightColor = vec3(0.869, 0.169, 0.169);
                    break;
            }
        #endif
        
        //lightColor = RGBToLinear(lightColor);

        #ifdef DYN_LIGHT_FLICKER
            // TODO: optimize branching
            //vec2 noiseSample = GetDynLightNoise(cameraPosition + blockLocalPos);
            float flickerNoise = GetDynLightFlickerNoise(noiseSample);
            float blackbodyTemp = 0.0;

            if (lightType == LIGHT_TORCH || lightType == LIGHT_LANTERN || lightType == LIGHT_FIRE || lightType == LIGHT_CAMPFIRE) {
                blackbodyTemp = mix(TEMP_FIRE_MIN, TEMP_FIRE_MAX, flickerNoise);
            }

            if (lightType == LIGHT_SOUL_TORCH || lightType == LIGHT_SOUL_LANTERN || lightType == LIGHT_SOUL_FIRE || lightType == LIGHT_SOUL_CAMPFIRE) {
                blackbodyTemp = mix(TEMP_SOUL_FIRE_MIN, TEMP_SOUL_FIRE_MAX, 1.0 - flickerNoise);
            }

            if (lightType == LIGHT_CANDLES_1 || lightType == LIGHT_CANDLES_2
             || lightType == LIGHT_CANDLES_3 || lightType == LIGHT_CANDLES_4
             || lightType == LIGHT_CANDLE_CAKE || (lightType >= LIGHT_JACK_O_LANTERN_N && lightType <= LIGHT_JACK_O_LANTERN_W)) {
                blackbodyTemp = mix(TEMP_CANDLE_MIN, TEMP_CANDLE_MAX, flickerNoise);
            }

            vec3 blackbodyColor = vec3(1.0);
            if (blackbodyTemp > 0.0)
                blackbodyColor = blackbody(blackbodyTemp);

            float flickerBrightness = 0.6 + 0.4 * flickerNoise;

            if (lightType == LIGHT_TORCH || lightType == LIGHT_LANTERN || lightType == LIGHT_FIRE || lightType == LIGHT_CAMPFIRE) {
                lightColor = LinearToRGB(flickerBrightness * blackbodyColor);
            }

            if (lightType == LIGHT_SOUL_TORCH || lightType == LIGHT_SOUL_LANTERN || lightType == LIGHT_SOUL_FIRE || lightType == LIGHT_SOUL_CAMPFIRE) {
                lightColor = LinearToRGB(flickerBrightness * saturate(1.0 - blackbodyColor));
            }

            if (lightType == LIGHT_CANDLES_1 || lightType == LIGHT_CANDLES_2
             || lightType == LIGHT_CANDLES_3 || lightType == LIGHT_CANDLES_4
             || lightType == LIGHT_CANDLE_CAKE || (lightType >= LIGHT_JACK_O_LANTERN_N && lightType <= LIGHT_JACK_O_LANTERN_W)) {
                lightColor = LinearToRGB(0.4 * flickerBrightness * blackbodyColor);
            }
        #endif

        return lightColor;
    }

    float GetSceneLightRange(const in uint lightType) {
        float lightRange = 0.0;

        switch (lightType) {
            case LIGHT_BLOCK_1:
                lightRange = 1.0;
                break;
            case LIGHT_BLOCK_2:
                lightRange = 2.0;
                break;
            case LIGHT_BLOCK_3:
                lightRange = 3.0;
                break;
            case LIGHT_BLOCK_4:
                lightRange = 4.0;
                break;
            case LIGHT_BLOCK_5:
                lightRange = 5.0;
                break;
            case LIGHT_BLOCK_6:
                lightRange = 6.0;
                break;
            case LIGHT_BLOCK_7:
                lightRange = 7.0;
                break;
            case LIGHT_BLOCK_8:
                lightRange = 8.0;
                break;
            case LIGHT_BLOCK_9:
                lightRange = 9.0;
                break;
            case LIGHT_BLOCK_10:
                lightRange = 10.0;
                break;
            case LIGHT_BLOCK_11:
                lightRange = 11.0;
                break;
            case LIGHT_BLOCK_12:
                lightRange = 12.0;
                break;
            case LIGHT_BLOCK_13:
                lightRange = 13.0;
                break;
            case LIGHT_BLOCK_14:
                lightRange = 14.0;
                break;
            case LIGHT_BLOCK_15:
                lightRange = 15.0;
                break;
            case LIGHT_AMETHYST_BUD_LARGE:
                lightRange = 4.0;
                break;
            case LIGHT_AMETHYST_BUD_MEDIUM:
                lightRange = 2.0;
                break;
            case LIGHT_AMETHYST_CLUSTER:
                lightRange = 5.0;
                break;
            case LIGHT_BEACON:
                lightRange = 15.0;
                break;
            case LIGHT_BLAST_FURNACE_N:
            case LIGHT_BLAST_FURNACE_E:
            case LIGHT_BLAST_FURNACE_S:
            case LIGHT_BLAST_FURNACE_W:
                lightRange = 6.0;
                break;
            case LIGHT_BREWING_STAND:
                lightRange = 2.0;
                break;
            case LIGHT_CANDLES_1:
            case LIGHT_CANDLE_CAKE:
                lightRange = 3.0;
                break;
            case LIGHT_CANDLES_2:
                lightRange = 6.0;
                break;
            case LIGHT_CANDLES_3:
                lightRange = 9.0;
                break;
            case LIGHT_CANDLES_4:
                lightRange = 12.0;
                break;
            case LIGHT_CAVEVINE_BERRIES:
                lightRange = 14.0;
                break;
            case LIGHT_COMPARATOR:
                lightRange = 7.0;
                break;
            case LIGHT_CRYING_OBSIDIAN:
                lightRange = 10.0;
                break;
            case LIGHT_END_ROD:
                lightRange = 14.0;
                break;
            case LIGHT_CAMPFIRE:
            case LIGHT_FIRE:
                lightRange = 15.0;
                break;
            case LIGHT_FROGLIGHT_OCHRE:
                lightRange = 15.0;
                break;
            case LIGHT_FROGLIGHT_PEARLESCENT:
                lightRange = 15.0;
                break;
            case LIGHT_FROGLIGHT_VERDANT:
                lightRange = 15.0;
                break;
            case LIGHT_FURNACE_N:
            case LIGHT_FURNACE_E:
            case LIGHT_FURNACE_S:
            case LIGHT_FURNACE_W:
                lightRange = 6.0;
                break;
            case LIGHT_GLOWSTONE:
                lightRange = 15.0;
                break;
            case LIGHT_GLOW_LICHEN:
                lightRange = 7.0;
                break;
            case LIGHT_JACK_O_LANTERN_N:
            case LIGHT_JACK_O_LANTERN_E:
            case LIGHT_JACK_O_LANTERN_S:
            case LIGHT_JACK_O_LANTERN_W:
                lightRange = 15.0;
                break;
            case LIGHT_LANTERN:
                lightRange = 12.0;
                break;
            case LIGHT_LAVA:
                lightRange = 8.0;
                break;
            case LIGHT_LAVA_CAULDRON:
                lightRange = 15.0;
                break;
            case LIGHT_LIGHTING_ROD:
                lightRange = 8.0;
                break;
            case LIGHT_MAGMA:
                lightRange = 3.0;
                break;
            case LIGHT_NETHER_PORTAL:
                lightRange = 11.0;
                break;
            case LIGHT_REDSTONE_LAMP:
                lightRange = 15.0;
                break;
            case LIGHT_REDSTONE_TORCH:
                lightRange = 7.0;
                break;
            case LIGHT_REDSTONE_WIRE_1:
                lightRange = 1.0;
                break;
            case LIGHT_REDSTONE_WIRE_2:
                lightRange = 1.5;
                break;
            case LIGHT_REDSTONE_WIRE_3:
                lightRange = 2.0;
                break;
            case LIGHT_REDSTONE_WIRE_4:
                lightRange = 2.5;
                break;
            case LIGHT_REDSTONE_WIRE_5:
                lightRange = 3.0;
                break;
            case LIGHT_REDSTONE_WIRE_6:
                lightRange = 3.5;
                break;
            case LIGHT_REDSTONE_WIRE_7:
                lightRange = 4.0;
                break;
            case LIGHT_REDSTONE_WIRE_8:
                lightRange = 4.5;
                break;
            case LIGHT_REDSTONE_WIRE_9:
                lightRange = 5.0;
                break;
            case LIGHT_REDSTONE_WIRE_10:
                lightRange = 5.5;
                break;
            case LIGHT_REDSTONE_WIRE_11:
                lightRange = 6.0;
                break;
            case LIGHT_REDSTONE_WIRE_12:
                lightRange = 6.5;
                break;
            case LIGHT_REDSTONE_WIRE_13:
                lightRange = 7.0;
                break;
            case LIGHT_REDSTONE_WIRE_14:
                lightRange = 7.5;
                break;
            case LIGHT_REDSTONE_WIRE_15:
                lightRange = 8.0;
                break;
            case LIGHT_REPEATER:
                lightRange = 7.0;
                break;
            case LIGHT_RESPAWN_ANCHOR_1:
                lightRange = 3.0;
                break;
            case LIGHT_RESPAWN_ANCHOR_2:
                lightRange = 7.0;
                break;
            case LIGHT_RESPAWN_ANCHOR_3:
                lightRange = 11.0;
                break;
            case LIGHT_RESPAWN_ANCHOR_4:
                lightRange = 15.0;
                break;
            case LIGHT_SCULK_CATALYST:
                lightRange = 6.0;
                break;
            case LIGHT_SEA_LANTERN:
                lightRange = 15.0;
                break;
            case LIGHT_SEA_PICKLE_1:
                lightRange = 6.0;
                break;
            case LIGHT_SEA_PICKLE_2:
                lightRange = 9.0;
                break;
            case LIGHT_SEA_PICKLE_3:
                lightRange = 12.0;
                break;
            case LIGHT_SEA_PICKLE_4:
                lightRange = 15.0;
                break;
            case LIGHT_SHROOMLIGHT:
                lightRange = 15.0;
                break;
            case LIGHT_SMOKER_N:
            case LIGHT_SMOKER_E:
            case LIGHT_SMOKER_S:
            case LIGHT_SMOKER_W:
                lightRange = 6.0;
                break;
            case LIGHT_SOUL_CAMPFIRE:
            case LIGHT_SOUL_FIRE:
            case LIGHT_SOUL_LANTERN:
                lightRange = 12.0;
                break;
            case LIGHT_SOUL_TORCH:
                lightRange = 10.0;
                break;
            case LIGHT_TORCH:
                lightRange = 12.0;
                break;
        }

        #ifdef DYN_LIGHT_CONCRETE
            switch (lightType) {
                case LIGHT_CONCRETE_BLUE:
                case LIGHT_CONCRETE_GREEN:
                case LIGHT_CONCRETE_RED:
                    lightRange = 8.0;
                    break;
            }
        #endif

        #ifdef DYN_LIGHT_OREBLOCKS
            switch (lightType) {
                case LIGHT_AMETHYST_BLOCK:
                case LIGHT_DIAMOND_BLOCK:
                case LIGHT_EMERALD_BLOCK:
                case LIGHT_LAPIS_BLOCK:
                case LIGHT_REDSTONE_BLOCK:
                    lightRange = 12.0;
                    break;
            }
        #endif

        return lightRange * DynamicLightRangeF;
    }

    float GetSceneLightLevel(const in uint lightType) {
        #if DYN_LIGHT_REDSTONE == DYN_LIGHT_BLOCK_NONE
            if (lightType == LIGHT_COMPARATOR
             || lightType == LIGHT_REPEATER
             || lightType == LIGHT_RAIL_POWERED) return 0.0;

            if (lightType >= LIGHT_REDSTONE_WIRE_1
             && lightType <= LIGHT_REDSTONE_WIRE_15) return 0.0;
        #endif
        
        #if DYN_LIGHT_LAVA == DYN_LIGHT_BLOCK_NONE
            if (lightType == LIGHT_LAVA) return 0.0;
        #endif

        return GetSceneLightRange(lightType);
    }

    float GetSceneLightSize(const in uint lightType) {
        float size = (1.0/16.0);

        switch (lightType) {
            case LIGHT_AMETHYST_BLOCK:
            case LIGHT_AMETHYST_CLUSTER:
            case LIGHT_CRYING_OBSIDIAN:
            case LIGHT_FIRE:
            case LIGHT_FROGLIGHT_OCHRE:
            case LIGHT_FROGLIGHT_PEARLESCENT:
            case LIGHT_FROGLIGHT_VERDANT:
            case LIGHT_GLOWSTONE:
            case LIGHT_LAVA:
            case LIGHT_MAGMA:
            case LIGHT_SOUL_FIRE:
                size = (16.0/16.0);
                break;
            case LIGHT_LAVA_CAULDRON:
            case LIGHT_SEA_LANTERN:
            case LIGHT_REDSTONE_LAMP:
                size = (14.0/16.0);
                break;
            case LIGHT_AMETHYST_BUD_LARGE:
            case LIGHT_CAMPFIRE:
            case LIGHT_SOUL_CAMPFIRE:
                size = (12.0/16.0);
                break;
            case LIGHT_BEACON:
            case LIGHT_JACK_O_LANTERN_N:
            case LIGHT_JACK_O_LANTERN_E:
            case LIGHT_JACK_O_LANTERN_S:
            case LIGHT_JACK_O_LANTERN_W:
            case LIGHT_RAIL_POWERED:
                size = (10.0/16.0);
                break;
            case LIGHT_CANDLES_4:
            case LIGHT_END_ROD:
                size = (8.0/16.0);
                break;
            case LIGHT_AMETHYST_BUD_MEDIUM:
            case LIGHT_CANDLES_3:
            case LIGHT_LANTERN:
            case LIGHT_SOUL_LANTERN:
                size = (6.0/16.0);
                break;
            case LIGHT_CANDLES_2:
            case LIGHT_TORCH:
            case LIGHT_SOUL_TORCH:
                size = (4.0/16.0);
                break;
            case LIGHT_CANDLES_1:
            case LIGHT_CANDLE_CAKE:
            case LIGHT_REDSTONE_TORCH:
                size = (2.0/16.0);
                break;
        }

        return size;
    }

    vec3 GetSceneLightOffset(const in uint lightType) {
        vec3 lightOffset = vec3(0.0);

        switch (lightType) {
            case LIGHT_BLAST_FURNACE_N:
            case LIGHT_BLAST_FURNACE_E:
            case LIGHT_BLAST_FURNACE_S:
            case LIGHT_BLAST_FURNACE_W:
                lightOffset = vec3(0.0, -0.4, 0.0);
                break;
            case LIGHT_CANDLE_CAKE:
                lightOffset = vec3(0.0, 0.4, 0.0);
                break;
            case LIGHT_FIRE:
                lightOffset = vec3(0.0, -0.3, 0.0);
                break;
            case LIGHT_FURNACE_N:
            case LIGHT_FURNACE_E:
            case LIGHT_FURNACE_S:
            case LIGHT_FURNACE_W:
                lightOffset = vec3(0.0, -0.2, 0.0);
                break;
            case LIGHT_JACK_O_LANTERN_N:
                lightOffset = vec3(0.0, 0.0, -0.4) * DynamicLightPenumbraF;
                break;
            case LIGHT_JACK_O_LANTERN_E:
                lightOffset = vec3(0.4, 0.0, 0.0) * DynamicLightPenumbraF;
                break;
            case LIGHT_JACK_O_LANTERN_S:
                lightOffset = vec3(0.0, 0.0, 0.4) * DynamicLightPenumbraF;
                break;
            case LIGHT_JACK_O_LANTERN_W:
                lightOffset = vec3(-0.4, 0.0, 0.0) * DynamicLightPenumbraF;
                break;
            case LIGHT_LANTERN:
                lightOffset = vec3(0.0, -0.2, 0.0);
                break;
            case LIGHT_LAVA_CAULDRON:
                #if DYN_LIGHT_PENUMBRA > 0
                    lightOffset = vec3(0.0, 0.4, 0.0);
                #else
                    lightOffset = vec3(0.0, 0.2, 0.0);
                #endif
                break;
            case LIGHT_RESPAWN_ANCHOR_1:
            case LIGHT_RESPAWN_ANCHOR_2:
            case LIGHT_RESPAWN_ANCHOR_3:
            case LIGHT_RESPAWN_ANCHOR_4:
                lightOffset = vec3(0.0, 0.4, 0.0);
                break;
            case LIGHT_SCULK_CATALYST:
                lightOffset = vec3(0.0, 0.4, 0.0);
                break;
            case LIGHT_SMOKER_N:
            case LIGHT_SMOKER_E:
            case LIGHT_SMOKER_S:
            case LIGHT_SMOKER_W:
                lightOffset = vec3(0.0, -0.3, 0.0);
                break;
            case LIGHT_SOUL_FIRE:
            case LIGHT_SOUL_LANTERN:
                lightOffset = vec3(0.0, -0.25, 0.0);
                break;
            case LIGHT_TORCH:
            case LIGHT_SOUL_TORCH:
                lightOffset = vec3(0.0, (1.0/16.0), 0.0);
                break;
        }

        return lightOffset;
    }

    bool GetLightTraced(const in uint lightType) {
        bool result = true;

        #if DYN_LIGHT_GLOW_BERRIES != DYN_LIGHT_BLOCK_TRACE
            if (lightType == LIGHT_CAVEVINE_BERRIES) result = false;
        #endif

        #if DYN_LIGHT_LAVA != DYN_LIGHT_BLOCK_TRACE
            if (lightType == LIGHT_LAVA) result = false;
        #endif

        #if DYN_LIGHT_PORTAL != DYN_LIGHT_BLOCK_TRACE
            if (lightType == LIGHT_NETHER_PORTAL) result = false;
        #endif

        #if DYN_LIGHT_REDSTONE != DYN_LIGHT_BLOCK_TRACE
            if (lightType >= LIGHT_REDSTONE_WIRE_1 && lightType <= LIGHT_REDSTONE_WIRE_15) result = false;
        #endif

        return result;
    }

    #ifdef RENDER_SHADOWCOMP
        uint BuildLightMask(const in uint lightType) {
            uint lightData = 0u;

            switch (lightType) {
                case LIGHT_BEACON:
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    break;
                case LIGHT_JACK_O_LANTERN_N:
                case LIGHT_FURNACE_N:
                case LIGHT_BLAST_FURNACE_N:
                case LIGHT_SMOKER_N:
                    lightData |= 1u << LIGHT_MASK_UP;
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    lightData |= 1u << LIGHT_MASK_SOUTH;
                    lightData |= 1u << LIGHT_MASK_WEST;
                    lightData |= 1u << LIGHT_MASK_EAST;
                    break;
                case LIGHT_JACK_O_LANTERN_E:
                case LIGHT_FURNACE_E:
                case LIGHT_BLAST_FURNACE_E:
                case LIGHT_SMOKER_E:
                    lightData |= 1u << LIGHT_MASK_UP;
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    lightData |= 1u << LIGHT_MASK_NORTH;
                    lightData |= 1u << LIGHT_MASK_SOUTH;
                    lightData |= 1u << LIGHT_MASK_WEST;
                    break;
                case LIGHT_JACK_O_LANTERN_S:
                case LIGHT_FURNACE_S:
                case LIGHT_BLAST_FURNACE_S:
                case LIGHT_SMOKER_S:
                    lightData |= 1u << LIGHT_MASK_UP;
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    lightData |= 1u << LIGHT_MASK_NORTH;
                    lightData |= 1u << LIGHT_MASK_WEST;
                    lightData |= 1u << LIGHT_MASK_EAST;
                    break;
                case LIGHT_JACK_O_LANTERN_W:
                case LIGHT_FURNACE_W:
                case LIGHT_BLAST_FURNACE_W:
                case LIGHT_SMOKER_W:
                    lightData |= 1u << LIGHT_MASK_UP;
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    lightData |= 1u << LIGHT_MASK_NORTH;
                    lightData |= 1u << LIGHT_MASK_SOUTH;
                    lightData |= 1u << LIGHT_MASK_EAST;
                    break;
                case LIGHT_LAVA_CAULDRON:
                    lightData |= 1u << LIGHT_MASK_DOWN;
                    lightData |= 1u << LIGHT_MASK_NORTH;
                    lightData |= 1u << LIGHT_MASK_SOUTH;
                    lightData |= 1u << LIGHT_MASK_WEST;
                    lightData |= 1u << LIGHT_MASK_EAST;
                    break;
            }

            return lightData;
        }

        // BuildLightMask
        uvec4 BuildLightData(const in vec3 position, const in bool traced, const in uint mask, const in float size, const in float range, const in vec3 color) {
            uvec4 lightData;

            // position
            lightData.x  = float2half(floatBitsToUint(position.x));
            lightData.x |= float2half(floatBitsToUint(position.y)) << 16u;
            lightData.y  = float2half(floatBitsToUint(position.z));

            // size
            uint bitSize = uint(clamp(size * 255.0, 0.0, 255.0) + 0.5);
            lightData.y |= bitSize << 16u;

            // range
            uint bitRange = uint(clamp(range * 15.0, 0.0, 255.0) + 0.5);
            lightData.y |= bitRange << 24u;

            // traced
            lightData.z = traced ? 1u : 0u;

            // mask
            lightData.z |= mask;

            // color
            uvec3 bitColor = uvec3(saturate(color) * 255.0 + 0.5);
            lightData.z |= bitColor.r << 8u;
            lightData.z |= bitColor.g << 16u;
            lightData.z |= bitColor.b << 24u;

            return lightData;
        }
    #endif
#endif

void ParseLightPosition(const in uvec4 data, out vec3 position) {
    position.x = uintBitsToFloat(half2float(data.x & uint(0xffff)));
    position.y = uintBitsToFloat(half2float(data.x >> 16u));
    position.z = uintBitsToFloat(half2float(data.y & uint(0xffff)));
}

void ParseLightSize(const in uvec4 data, out float size) {
    size = ((data.y >> 16u) & 255u) / 255.0;
}

void ParseLightRange(const in uvec4 data, out float range) {
    range = ((data.y >> 24u) & 255u) / 15.0;
}

void ParseLightColor(const in uvec4 data, out vec3 color) {
    color.r = ((data.z >>  8u) & 255u) / 255.0;
    color.g = ((data.z >> 16u) & 255u) / 255.0;
    color.b = ((data.z >> 24u) & 255u) / 255.0;
}

void ParseLightData(const in uvec4 data, out vec3 position, out float size, out float range, out vec3 color) {
    ParseLightPosition(data, position);
    ParseLightSize(data, size);
    ParseLightRange(data, range);
    ParseLightColor(data, color);
}
