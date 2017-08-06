module Shader.Day6 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        vec2 uv = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy);
        // Divide by smallest side to make that go from -1.0 to 1.0
        uv /= min(u_resolution.y, u_resolution.x);

        vec3 col1 = vec3(0.482, 0.675, 0.69);
        vec3 col2 = vec3(0.09, 0.208, 0.49);
        vec3 col3 = vec3(0.992, 0.122, 0.455);

        // Mirror coordinates
        uv = abs(uv);
        // Combine various functions to get an interesting effect
        float d = abs(sin(pow(atan(uv.x, uv.y * uv.x) * 7.3, 4.0) + u_time * 0.4));
        // Size of sphere
        float r = 0.6 * d;
        float c1 = length(uv);
        // Use smoothstep with some "random" values to create noise like effect
        c1 = smoothstep(uv.x / uv.y, sin(r * 8.0 + 0.005), c1);
        vec3 color = mix(col3, col1, c1);
        // Apply some vignetting around the borders
        color = mix(color, col2, (0.21 * pow(distance(uv, vec2(0.0)), 2.0)));

        gl_FragColor = vec4(color, 1.0);
    }

|]
