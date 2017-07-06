module Shader.Tutorial.Smoothstep exposing (..)

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

        float variable, edge, ret;

        ret = 1.0;
        if (p.x < 1.0 / 5.0) {
            edge = 0.5;
            ret = step(edge, r.y);
        } else if (p.x < 2.0 / 5.0) {
            // linearstep (not a builtin function)
            float edge0 = 0.45;
            float edge1 = 0.55;
            float t = (p.y - edge0)/(edge1 - edge0);
            // when p.y == edge0 => t = 0.0
            // when p.y == edge1 => t = 1.0
            // RHS is a linear function of y
            // so, between edge0 and edge1, t has a linear transition
            // between 0.0 and 1.0
            float t1 = clamp(t, 0.0, 1.0);
            // t will have negative values when t<edge0 and
            // t will have greater than 1.0 values when t>edge1
            // but we want it be constraint between 0.0 and 1.0
            // so, clamp it!
            ret = t1;
        } else if (p.x < 3.0 / 5.0) {
            // implementation of smoothstep
            float edge0 = 0.45;
            float edge1 = 0.55;
            float t = clamp((p.y - edge0)/(edge1 - edge0), 0.0, 1.0);
            float t1 = 3.0*t*t - 2.0*t*t*t;
            // previous interpolation was linear. Visually it does not
            // give an appealing, smooth transition.
            // To achieve smoothness, implement a cubic Hermite polynomial
            // 3*t^2 - 2*t^3
            ret = t1;
        } else if (p.x < 4.0 / 5.0) {
            ret = smoothstep(0.45, 0.55, p.y);
        } else {
            // smootherstep, a suggestion by Ken Perlin
            float edge0 = 0.45;
            float edge1 = 0.55;
            float t = clamp((p.y - edge0)/(edge1 - edge0), 0.0, 1.0);
            // 6*t^5 - 15*t^4 + 10*t^3
            float t1 = t*t*t*(t*(t*6. - 15.) + 10.);
            ret = t1;
            // faster transition and still smoother
            // but computationally more involved.
        }

        pixel = vec3(ret);
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
