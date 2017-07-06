module Shader.Tutorial.Mouse exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    // returns 1.0 if inside circle
    float disk(vec2 r, vec2 center, float radius) {
        return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
    }

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        float xMax = u_resolution.x / u_resolution.y;

        vec3 bgCol = vec3(u_mouse.x / u_resolution.x);
        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // yellow
        vec3 col3 = vec3(0.867, 0.910, 0.247); // red
        vec3 ret = bgCol;

        vec2 center = vec2(100.0, u_resolution.y / 2.0);
        float radius = 60.0;

        // if the cursor coordinates is inside the disk
        if (length(u_mouse.xy - center) > radius) {
            // use color3
            ret = mix(ret, col3, disk(gl_FragCoord.xy, center, radius));
        }
        else {
            // else use color2
            ret = mix(ret, col2, disk(gl_FragCoord.xy, center, radius));
        }

        // draw the small blue disk at the cursor
        center = u_mouse.xy;
        ret = mix(ret, col1, disk(gl_FragCoord.xy, center, 20.0));

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
