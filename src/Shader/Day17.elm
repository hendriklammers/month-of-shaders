module Shader.Day17 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    const vec3 yellow = vec3(1.0, 0.776, 0.102);
    const vec3 pink = vec3(0.886, 0.004, 0.404);
    const vec3 blue = vec3(0.012, 0.58, 0.906);

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        // Break coordinate system in 6
        uv = abs(fract(uv * 3.0) - 0.5);
        // Rotate each section
        uv = uv * rotate(u_time * 0.5);
        // normalize time and slow down
        float t = abs(fract(u_time * 0.2) * 2.0 - 1.0);
        // Round to create solid shapes and add x to y to create diagonal shapes
        float o = floor(length(uv.x + uv.y) * 10.0) / 10.0;
        vec3 c1 = mix(yellow, blue, t);
        vec3 c2 = mix(pink, blue, t);
        vec3 color = mix(c1, pink, o);
        gl_FragColor = vec4(color, 1.0);
    }

|]
