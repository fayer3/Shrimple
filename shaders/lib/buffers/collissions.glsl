struct CollissionData {
    uint Count;                     // 4
    uvec2 Bounds[BLOCK_MASK_PARTS]; // 48
};

#ifdef RENDER_SETUP
    layout(std430, binding = 4) writeonly buffer collissionData
#else
    layout(std430, binding = 4) readonly buffer collissionData
#endif
{
    CollissionData CollissionMaps[];   // 52 * 1200 = 62400
};
