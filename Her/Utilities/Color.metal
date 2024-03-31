//
//  Color.metal
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 color(
    float2 position,
    half4 color
) {
    return half4(position.x/255.0, position.y/255.0, 0.0, 1.0);
}

[[ stitchable ]]
half4 sizeAwareColor(
    float2 position,
    half4 color,
    float2 size
) {
    return half4(position.x/size.x, position.y/size.y, position.x/size.y, 1.0);
}

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}

//[[ stitchable ]]
//half4 timeVaryingColor(
//    float2 position,
//    half4 color,
//    float2 size,
//    float time
//) {
//    return half4(oscillate(2 * time + position.x/size.x),
//                 oscillate(4 * time + position.y/size.y),
//                 oscillate(-2 * time + position.x/size.y),
//                 1.0);
//}

//[[ stitchable ]]
//half4 timeVaryingColor(
//    float2 position,
//    half4 color,
//    float2 size,
//    float time
//) {
//    return half4(0.1 + 0.1 * oscillate(2 * time + position.x/size.x), // Dark blue oscillating
//                 0.3 + 0.3 * oscillate(4 * time + position.y/size.y), // Medium blue oscillating
//                 0.6 + 0.4 * oscillate(-2 * time + position.x/size.y), // Medium blue oscillating
//                 1.0
//
//                 );
//
//}

//[[ stitchable ]]
//half4 timeVaryingColor(
//    float2 position,
//    half4 color,
//    float2 size,
//    float time
//) {
//    return half4(0.1 + 0.1 * oscillate(1 * time + position.x/size.x), // Dark blue oscillating (slowed down)
//                 0.3 + 0.2 * oscillate(2 * time + position.y/size.y), // Medium blue oscillating (slowed down)
//                 0.5 + 0.2 * oscillate(-1 * time + position.x/size.y), // Medium blue oscillating (slowed down)
//                 0.2 + 0.2 * oscillate(1.5 * time + position.y/size.x)); // Green oscillating
//}

//[[ stitchable ]]
//half4 timeVaryingColor(
//    float2 position,
//    half4 color,
//    float2 size,
//    float time
//) {
//    half4 oscColor = half4(0.1 + 0.1 * oscillate(1 * time + position.x/size.x), // Dark blue oscillating (slowed down)
//                           0.3 + 0.2 * oscillate(2 * time + position.y/size.y), // Medium blue oscillating (slowed down)
//                           0.5 + 0.2 * oscillate(-1 * time + position.x/size.y), // Medium blue oscillating (slowed down)
//                           0.2 + 0.2 * oscillate(1.5 * time + position.y/size.x)); // Green oscillating
//
//    // Check if the color is close to white
//    if (oscColor.r > 0.9 && oscColor.g > 0.9 && oscColor.b > 0.9) {
//        // Replace white with light blue
//        return half4(0.8, 0.9, 1.0, 1.0);
//    }
//    else {
//        return oscColor;
//    }
//}



[[ stitchable ]]
half4 timeVaryingColor(
    float2 position,
    half4 color,
    float2 size,
    float time
) {
    // Convert angles from degrees to radians
    float angle1 = 0.0 * (M_PI_F / 180.0);
    float angle2 = 33.0 * (M_PI_F / 180.0);
    float angle3 = 66.0 * (M_PI_F / 180.0);
    float angle4 = 99.0 * (M_PI_F / 180.0);

    // Calculate the oscillation values based on angles
    float osc1 = oscillate(0.5 * time + dot(position/size, float2(cos(angle1), sin(angle1))));
    float osc2 = oscillate(1 * time + dot(position/size, float2(cos(angle2), sin(angle2))));
    float osc3 = oscillate(2 * time + dot(position/size, float2(cos(angle3), sin(angle3))));
    float osc4 = oscillate(3 * time + dot(position/size, float2(cos(angle4), sin(angle4))));

    half4 oscColor = half4(0.1 + 0.1 * osc1, // Dark blue oscillating (slowed down)
                           0.3 + 0.2 * osc2, // Medium blue oscillating (slowed down)
                           0.5 + 0.2 * osc3, // Medium blue oscillating (slowed down)
                           0.2 + 0.2 * osc4); // Green oscillating

    // Check if the color is close to white
    if (oscColor.r > 0.9 && oscColor.g > 0.9 && oscColor.b > 0.9) {
        // Replace white with light blue
        return half4(0.9, 0.2, 0.2, 1.0);
    }
    else {
        return oscColor;
    }
}


//[[ stitchable ]]
//half4 color(float2 position, half4 color) {
//return half4(position.x/255.0, position.y/255.0, 0.0, 1.0));
//}
//
//[[ stitchable ]]
//half4 sizeAwareColor(float2 position, half4 color, float2 size) {
//return half4(position.x/size.x, position.y/size.y, position.x/size.y, 1.0));
//}

//// Updated colour function to add three more nice colours
//[[ stitchable ]]
//half4 timeVaryingColor(float2 position, half4 color, float2 size, float time) {
//
// // Convert angles from degrees to radians
// float angle1 = 30.0 * (M_PI_F / 180.0);
// float angle2 = 60.0 * (M_PI_F / 180.0);
// float angle3 = 90.0 * (M_PI_F / 180.0);
//
// // Calculate the oscillation values based on angles
// float osc1 = oscillate(1 * time + dot(position/size, float2(cos(angle1), sin(angle1))));
// float osc2 = oscillate(2 * time + dot(position/size, float2(cos(angle2), sin(angle2))));
// float osc3 = oscillate(-1 * time + dot(position/size, float2(cos(angle3), sin(angle3))));
//
// // Convert colors from RGB to HSV
// half4 hsvColor = colorToHsv(half4(osc1, osc2, osc3, 1.0);
//
// // Check if the color is close to white
// if (hsvColor.r > 0.9 && hsvColor.g > 0.9 && hsvColor.b > 0.9) {
//
// // Replace white with light blue
// return half4(hsvColor.h, hsvColor.s, 0.8, 1.0);
//
// } else {
//
// // Return the color as it is
// return half4(hsvColor.r, hsvColor.g, hsvColor.b, 1.0);
//
// }
//}
//
//// Function to convert RGB to HSV
//half4 rbgToHsv(half4 rgb) {
//
// // Convert RGB values from [0, 255] range to [0, 1] range
// half4 scaledRgb = half4(rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0, 1.0));
//
// // Calculate the maximum value among the three components of RGB
// float maxValue = max(scaledRgb.r, scaledRgb.g, scaledRgb.b);
//
// // Calculate the minimum value among the three components of RGB
// float minValue = min(scaledRgb.r, scaledRgb.g, scaledRgb.b);
//
// // Calculate the hue component of HSV using the formula:
// // h = (maxVal - minVal) / (maxVal + minVal) * 360 degrees
// half hsvHue;
// if (maxValue == minValue) {
// hsvHue = half(scaledRgb.r, scaledRgb.g, scaledRgb.b, 1.0);
//} else {
// float hueDifference = (maxValue - minValue) / (maxValue + minValue);
// if (hueDifference < 0) {
// hsvHue = half((1 + hueDifference) * 60.0, 0, 360);
//} else {
// hsvHue = half(scaledRgb.r, scaledRgb.g, scaledRgb.b, 1.0);
// }
//}
//
//// Calculate the saturation component of HSV using the formula:
// // s = (maxVal - minVal) / maxVal if maxVal > 0 else 0
// half hsvSaturation;
// float deltaValue = maxValue - minValue;
// if (deltaValue > 0)) {
// hsvSaturation = half(deltaValue / maxValue);
//} else {
// hsvSaturation = half(0));
//}
//
//// Calculate the value component of HSV using the formula:
// // v = maxVal / maxValue if maxValue > 0 else 0
// half hsvValue;
// if (maxValue > 0)) {
// hsvValue = half(maxValue / maxValue);
//} else {
// hsvValue = half(0));
//}
//
//// Return the converted HSV color value
//return half4(hsvHue, hsvSaturation, hsvValue, 1.0));
//}
