module Shader.Day9 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        // colors
        vec3 c1 = vec3(0.02, 0.016, 0.078);
        vec3 c2 = vec3(0.165, 0.145, 0.365);
        vec3 c3 = vec3(0.431, 0.392, 0.608);
        vec3 c4 = vec3(0.929, 0.282, 0.514);
        vec3 c5 = vec3(1.0, 0.443, 0.302);

        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        uv *= 5.5; // zoom out

        float speed = u_time * 0.6;

        // Horizontal
        float h = sin(uv.x + speed);
        // Vertical
        float v = sin(uv.y + speed);
        // Diagonal
        float d = sin(uv.x + uv.y + speed);
        // Radial
        float r = sin(length(uv) + 1.7 * speed);
        // Combine waves
        float w = h * v * d + r;

        // Use the waves to mix the colors
        vec3 color = mix(c2, c3, sin(w * 1.1));
        color = mix(color, c4, cos(w * 2.1));
        color = mix(color, c5, tan(w * 1.7));

        gl_FragColor = vec4(color,1.0);
    }

|]
