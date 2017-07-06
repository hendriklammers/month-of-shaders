module Shader.Tutorial.Clamp exposing (..)

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
        float twopi = 6.28318530718;
        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);

        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // red
        vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow
        vec3 pixel = vec3(0.0);

        float variable, edge, ret;

        if (p.x < 0.25) {
            ret = p.y;
        } else if (p.x < 0.5) {
            float minVal = 0.3;
            float maxVal = 0.6;
            variable = p.y;

            // clamp implementation
            if (variable < minVal) {
                ret = minVal;
            } else if (variable > maxVal) {
                ret = maxVal;
            } else {
                ret = variable;
            }
        } else if (p.x < 0.75) {
            float minVal = 0.6;
            float maxVal = 0.8;
            variable = p.y;

            ret = clamp(variable, minVal, maxVal);
        } else {
            float y = cos(5.0 * twopi * p.y); // oscillate between +1 and -1
            // 5 times, vertically
            y = (y + 1.0) * 0.5; // map [-1,1] to [0,1]
            ret = clamp(y, 0.2, 0.8);
        }

        pixel = vec3(ret);
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
