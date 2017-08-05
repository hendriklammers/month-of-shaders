module Shader.Day5 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        vec2 p = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

        vec3 red = vec3(0.8, 0.2, 0.247);
        vec3 yellow = vec3(0.929, 0.788, 0.318);

        // Use a matrix to rotate the coordinates over time
        p *= mat2(cos(u_time * 0.5), -sin(u_time * 0.5), sin(u_time * 0.5), cos(u_time * 0.5));
        // Divide coordinates in 4 parts
        p = abs(p);
        // Just playing around to get an interesting effect
        p = ceil((p - u_time * 0.23) * 22.0) * 0.5;
        float pct = mod((p.x * 0.35 + p.y * 0.35), 2.0);

        vec3 color = mix(yellow, red, pct);

        gl_FragColor = vec4(color, 1.0);
    }

|]
