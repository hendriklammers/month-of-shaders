module Shader.Tutorial.Disks exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    void disk(vec2 r, vec2 center, float radius, vec3 color, inout vec3 pixel) {
        if (length(r - center) < radius) {
            pixel = color;
        }
    }

    void main () {
        // vec2 r = vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy); // 400 - (0.5 * 1600) = -400
        // r = 2.0 * r.xy / u_resolution.y;                        // (2 * -400) / 800 = -1

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // red
        vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow
        vec3 pixel = vec3(0.0);

        // float radius = 0.8;
        // if (r.x * r.x + r.y * r.y < radius * radius) {
        //     pixel = col1;
        // }

        // There is a shorthand expression for sqrt(v.x*v.x + v.y*v.y)
        // of a given vector "v", which is "length(v)"
        // if(length(r) < 0.3) {
        //     pixel = col3;
        // }

        // vec2 center = vec2(0.9, -0.4);
        // if (length(r - center) < 0.6) {
        //     pixel = col2;
        // }

        disk(r, vec2(1.0, 0.5), 0.2, col3, pixel);

        for (float i = -1.0; i < 1.0; i += 0.2) {
            disk(r, vec2(i, -i), 0.02, col1, pixel);
        }

        gl_FragColor = vec4(pixel, 1.0);
    }

|]
