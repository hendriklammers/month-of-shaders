module Shader.Tutorial.Mix exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);

        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // red
        vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow
        vec3 pixel = vec3(0.0);

        vec3 ret = vec3(1.0);
        if (p.x < 1.0 / 5.0) {
            // implementation of mix
            float x0 = 0.2; // first item to be mixed
            float x1 = 0.7;  // second item to be mixed
            float m = 0.1; // amount of mix (between 0.0 and 1.0)

            float val = x0 * (1.0 - m) + x1 * m;
            ret = vec3(val);
        } else if (p.x < 2.0 / 5.0) {
            float x0 = 0.2;
            float x1 = 0.7;
            float m = p.y;

            float val = x0 * (1.0 - m) + x1 * m;
            ret = vec3(val);
        } else if (p.x < 3.0 / 5.0) {
            float x0 = 0.2;
            float x1 = 0.7;
            float m = p.y;

            float val = mix(x0, x1, m);
            ret = vec3(val);
        } else if (p.x < 4.0 / 5.0) {
            // Mix colors
            float m = p.y;
            ret = mix(col1, col2, m);
        } else {
            // combine smoothstep and mix for color transition
            float m = smoothstep(0.25, 0.5, p.y);
            ret = mix(col1, col2, m);
        }

        pixel = vec3(ret);
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
