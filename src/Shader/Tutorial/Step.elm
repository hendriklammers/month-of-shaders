module Shader.Tutorial.Step exposing (..)

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
        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        float xMax = u_resolution.x / u_resolution.y;

        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // red
        vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow
        vec3 pixel = vec3(0.0);

        float variable, edge, ret;

        if(r.x < -0.6 * xMax) { // Part I
            variable = r.y;
            edge = 0.2;
            if( variable > edge ) { // if the "variable" is greater than "edge"
                ret = 1.0;          // return 1.0
            } else {                // if the "variable" is less than "edge"
                ret = 0.0;          // return 0.0
            }
        } else if (r.x < -0.2 * xMax) {
            variable = r.y;
            edge = 0.2;
            // step function is equivalent to the if block of the Part I
            ret = step(edge, variable);
        } else if (r.x < 0.2 * xMax) {
            ret = 1.0 - step(0.5, r.y);
        } else if (r.x < 0.6 * xMax) {
            // if y-coordinate is smaller than -0.4 ret is 0.3
            // if y-coordinate is greater than -0.4 ret is 0.3+0.5=0.8
            ret = 0.3 + 0.5*step(-0.4, r.y);
        } else {
            // Combine two step functions to create a gap
            ret = step(-0.3, r.y) * (1.0 - step(0.2, r.y));
        }

        pixel = vec3(ret);
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
