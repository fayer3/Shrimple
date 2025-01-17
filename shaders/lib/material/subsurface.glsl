float GetBlockSSS(const in int blockId) {
    float sss = 0.0;

    // 100
    switch (blockId) {
        case BLOCK_BROWN_MUSHROOM_PLANT:
        case BLOCK_LILY_PAD:
        case BLOCK_NETHER_WART:
        case BLOCK_RED_MUSHROOM_PLANT:
            sss = 0.2;
            break;
        case BLOCK_AZALEA:
        case BLOCK_BIG_DRIPLEAF:
        case BLOCK_BIG_DRIPLEAF_STEM:
        case BLOCK_CAVE_VINE:
        case BLOCK_CAVEVINE_BERRIES:
        case BLOCK_FERN:
        case BLOCK_KELP:
        case BLOCK_LARGE_FERN_LOWER:
        case BLOCK_LARGE_FERN_UPPER:
        case BLOCK_SAPLING:
        case BLOCK_SEAGRASS:
        case BLOCK_SMALL_DRIPLEAF:
        case BLOCK_SWEET_BERRY_BUSH:
        case BLOCK_TWISTING_VINES:
        case BLOCK_VINE:
        case BLOCK_WEEPING_VINES:
            sss = 0.4;
            break;
        case BLOCK_ALLIUM:
        case BLOCK_AZURE_BLUET:
        case BLOCK_BEETROOTS:
        case BLOCK_BLUE_ORCHID:
        case BLOCK_CARROTS:
        case BLOCK_CORNFLOWER:
        case BLOCK_DANDELION:
        case BLOCK_LILAC_LOWER:
        case BLOCK_LILAC_UPPER:
        case BLOCK_LILY_OF_THE_VALLEY:
        case BLOCK_OXEYE_DAISY:
        case BLOCK_PEONY_LOWER:
        case BLOCK_PEONY_UPPER:
        case BLOCK_POPPY:
        case BLOCK_POTATOES:
        case BLOCK_ROSE_BUSH_LOWER:
        case BLOCK_ROSE_BUSH_UPPER:
        case BLOCK_SPORE_BLOSSOM:
        case BLOCK_SUNFLOWER_LOWER:
        case BLOCK_SUNFLOWER_UPPER:
        case BLOCK_TULIP:
        case BLOCK_WHEAT:
        case BLOCK_WITHER_ROSE:
            sss = 0.6;
            break;
        case BLOCK_GRASS:
        case BLOCK_TALL_GRASS_UPPER:
        case BLOCK_TALL_GRASS_LOWER:
            sss = 0.8;
            break;
    }

    // 200
    switch (blockId) {
        case BLOCK_AMETHYST:
        case BLOCK_DIAMOND:
        case BLOCK_EMERALD:
            sss = 0.4;
            break;
    }

    // 500
    switch (blockId) {
        case BLOCK_SNOW_LAYERS_1:
        case BLOCK_SNOW_LAYERS_2:
        case BLOCK_SNOW_LAYERS_3:
        case BLOCK_SNOW_LAYERS_4:
        case BLOCK_SNOW_LAYERS_5:
        case BLOCK_SNOW_LAYERS_6:
        case BLOCK_SNOW_LAYERS_7:
            sss = 0.6;
            break;
    }

    // 600
    switch (blockId) {
        case BLOCK_HONEY:
            sss = 0.8;
            break;
        case BLOCK_LEAVES:
            sss = 0.4;
            break;
        case BLOCK_SNOW:
            sss = 0.6;
            break;
    }

    // 1000
    switch (blockId) {
        case BLOCK_MUSHROOM_STEM:
            sss = 0.2;
            break;
        case BLOCK_BROWN_MUSHROOM:
        case BLOCK_RED_MUSHROOM:
            sss = 0.4;
            break;
        case BLOCK_PACKED_ICE:
            sss = 0.6;
            break;
        case BLOCK_HONEYCOMB:
            sss = 0.8;
            break;
    }

    return sss;
}

#ifdef RENDER_ENTITIES
    float GetEntitySSS(const in int entityId) {
        float sss = 0.0;

        switch (entityId) {
            case ENTITY_SLIME:
                sss = 0.9;
                break;
        }

        return sss;
    }
#endif

#ifdef RENDER_FRAG
    float GetMaterialSSS(const in int id, const in vec2 texcoord, const in mat2 dFdXY) {
        float sss = 0.0;

        #ifdef RENDER_ENTITIES
            if (entityId == ENTITY_PHYSICSMOD_SNOW) return 0.8;
        #endif

        #if MATERIAL_SSS == SSS_LABPBR
            sss = textureGrad(specular, texcoord, dFdXY[0], dFdXY[1]).b;
            sss = max(sss - 0.25, 0.0) / 0.75;
        #elif MATERIAL_SSS == SSS_DEFAULT
            int materialId = id;
            #if (defined RENDER_HAND || defined RENDER_ENTITIES) && defined IS_IRIS
                if (currentRenderedItemId > 0)
                    materialId = currentRenderedItemId;
            #endif

            #ifdef RENDER_HAND
                sss = GetBlockSSS(materialId);
            #elif defined RENDER_TERRAIN || defined RENDER_WATER
                sss = GetBlockSSS(materialId);
            #elif defined RENDER_ENTITIES
                sss = GetEntitySSS(materialId);
            #endif
        #endif

        return sss;
    }
#endif
