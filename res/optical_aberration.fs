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

void main()
{
   vec2 normalized = fragTexCoord * 2 - 1;
   float distortion_magnitude = abs(normalized[0] * normalized[1]);
   //float smooth_distortion_magnitude = pow(distortion_magnitude, lens_tightness);
   float smooth_distortion_magnitude = 1-sqrt(1-pow(distortion_magnitude, lens_tightness));

   vec2 distorted = fragTexCoord + (normalized * lens_strength)/4 + normalized * smooth_distortion_magnitude * lens_strength;
   

   float blue = texture(texture0, distorted).b;
   float green = texture(texture0, distorted).g;
   float red = texture(texture0, distorted).r;
   finalColor = vec4(red, green, blue, 1.0);
   if (distorted[0] < 0 || distorted[0] > 1 || distorted[1] < 0 || distorted[1] > 1) {
      finalColor = vec4(0.05, 0.05, 0.05, 0.0);
   }
}
