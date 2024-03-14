#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D texture0;
uniform vec4 colDiffuse;

// Output fragment color
out vec4 finalColor;

// NOTE: Add here your custom variables
uniform float lens_tightness = 3;
uniform float lens_strength = 0.00; // positive = barrel, negative = pincushion
uniform float _LensDistortionOffset_R = 0.60;
uniform float _LensDistortionOffset_G = 1.00;
uniform float _LensDistortionOffset_B = 1.40;

bool isOutOfBound = false;

void main()
{
   vec2 normalized = fragTexCoord * 2 - 1;
   float distortion_magnitude = abs(normalized[0] * normalized[1]);
   //float smooth_distortion_magnitude = pow(distortion_magnitude, lens_tightness);
   float smooth_distortion_magnitude = 1-sqrt(1-pow(distortion_magnitude, lens_tightness));

   vec2 distorted = fragTexCoord + (normalized * lens_strength)/4 + normalized * smooth_distortion_magnitude * lens_strength;

   //float blue = texture(texture0, distorted).b;
   //float green = texture(texture0, distorted).g;
   //float red = texture(texture0, distorted).r;
   //finalColor = vec4(red, green, blue, 1.0);
   finalColor = vec4(0.0, 0.0, 0.0, 1.0);
   //if (distorted[0] < 0 || distorted[0] > 1 || distorted[1] < 0 || distorted[1] > 1) {
   //   finalColor = vec4(0.05, 0.05, 0.05, 0.0);
   //}
   
   // https://blog.yarsalabs.com/lens-distortion-and-chromatic-aberration-unity-part2/
   //vec2 uvRed = fragTexCoord + normalized * smooth_distortion_magnitude * (lens_strength + _LensDistortionOffset_R);
   //vec2 uvGreen = fragTexCoord + normalized * smooth_distortion_magnitude * (lens_strength + _LensDistortionOffset_G);
   //vec2 uvBlue = fragTexCoord + normalized * smooth_distortion_magnitude * (lens_strength + _LensDistortionOffset_B);
   vec2 uvRed = fragTexCoord + (normalized * lens_strength)/4 + normalized * smooth_distortion_magnitude * (lens_strength * _LensDistortionOffset_R);
   vec2 uvGreen = fragTexCoord + (normalized * lens_strength)/4 + normalized * smooth_distortion_magnitude * (lens_strength * _LensDistortionOffset_G);
   vec2 uvBlue = fragTexCoord + (normalized * lens_strength)/4 + normalized * smooth_distortion_magnitude * (lens_strength * _LensDistortionOffset_B);

   if (uvRed[0] < 0 || uvRed[0] > 1 || uvRed[1] < 0 || uvRed[1] > 1) {
    isOutOfBound = true;
  } else {
    finalColor[0] = texture(texture0, uvRed)[0];
  }

if (uvGreen[0] < 0 || uvGreen[0] > 1 || uvGreen[1] < 0 || uvGreen[1] > 1) {
    isOutOfBound = true;
  } else {
    finalColor[1] = texture(texture0, uvGreen)[1];
  }

if (uvBlue[0] < 0 || uvBlue[0] > 1 || uvBlue[1] < 0 || uvBlue[1] > 1) {
    isOutOfBound = true;
  } else {
    finalColor[2] = texture(texture0, uvBlue)[2];
  }

if (isOutOfBound) {
    finalColor = vec4(0.05, 0.05, 0.05, 0.0);
  }

}
