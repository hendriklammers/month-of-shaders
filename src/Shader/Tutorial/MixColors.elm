module Shader.Tutorial.MixColors exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    // A function that returns the 1.0 inside the disk area
    // returns 0.0 outside the disk area
    // and has a smooth transition at the radius
    float disk(vec2 r, vec2 center, float radius) {
        float distanceFromCenter = length(r - center);
        float outsideOfDisk = smoothstep(radius - 0.002, radius + 0.002, distanceFromCenter);
        float insideOfDisk = 1.0 - outsideOfDisk;
        return insideOfDisk;
    }

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        float xMax = u_resolution.x / u_resolution.y;

        vec3 black = vec3(0.0);
        vec3 white = vec3(1.0);
        vec3 gray = vec3(0.3);
        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // red
        vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow

        vec3 ret = vec3(1.0);
        float d;

        if (p.x < 1.0 / 3.0) {
            ret = gray;

            d = disk(r, vec2(-1.1, 0.3), 0.4);
            ret = mix(ret, col1, d);

            d = disk(r, vec2(-1.3, 0.0), 0.3);
            ret = mix(ret, col2, d);

            d = disk(r, vec2(-1.0, -0.1), 0.2);
            ret = mix(ret, col3, d); // here, previous color can be gray, blue or pink.
        } else if (p.x < 2.0 / 3.0) {
            // Color addition
            // http://en.wikipedia.org/wiki/Additive_color
            ret = black;
            ret += disk(r, vec2(0.1, 0.3), 0.4) * col1;
            ret += disk(r, vec2(-0.1, 0.0), 0.4) * col2;
            ret += disk(r, vec2(0.15, -0.3), 0.4) * col3;
        } else {
            // Color substraction
            // http://en.wikipedia.org/wiki/Subtractive_color
            ret = white;
            ret -= disk(r, vec2(1.1, 0.3), 0.4) * col1;
            ret -= disk(r, vec2(1.05, 0.0), 0.4) * col2;
            ret -= disk(r, vec2(1.35, -0.25), 0.4) * col3;
        }

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
