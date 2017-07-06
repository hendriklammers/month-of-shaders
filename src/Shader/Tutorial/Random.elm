module Shader.Tutorial.Random exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    float hash(float seed) {
        // Return a "random" number based on the "seed"
        return fract(sin(seed) * 43758.5453);
    }

    vec2 hashPosition(float x)
    {
        // Return a "random" position based on the "seed"
        return vec2(hash(x), hash(x * 1.1));
    }

    float disk(vec2 r, vec2 center, float radius) {
        return smoothstep(radius - 0.005, radius + 0.005, length(r - center));
    }

    float coordinateGrid(vec2 r) {
        vec3 axesCol = vec3(0.0, 0.0, 1.0);
        vec3 gridCol = vec3(0.5);
        float ret = 0.0;

        // Draw grid lines
        const float tickWidth = 0.1;
        for(float i = -2.0; i < 2.0; i += tickWidth) {
            // "i" is the line coordinate.
            ret += 1.0 - smoothstep(0.0, 0.005, abs(r.x - i));
            ret += 1.0 - smoothstep(0.0, 0.01, abs(r.y - i));
        }
        // Draw the axes
        ret += 1.0 - smoothstep(0.001, 0.005, abs(r.x));
        ret += 1.0 - smoothstep(0.001, 0.005, abs(r.y));
        return ret;
    }

    float plot(vec2 r, float y, float thickness) {
        return ( abs(y - r.y) < thickness ) ? 1.0 : 0.0;
    }

    void main () {
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        vec2 r =  2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        float xMax = u_resolution.x / u_resolution.y;

        vec3 bgCol = vec3(0.3);
        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // yellow
        vec3 col3 = vec3(0.867, 0.910, 0.247); // red

        vec3 ret = bgCol;

        vec3 white = vec3(1.0);
        vec3 gray = vec3(0.3);
        if(r.y > 0.7) {

            // translated and rotated coordinate system
            vec2 q = (r - vec2(0.0, 0.9)) * vec2(1.0, 20.0);
            ret = mix(white, gray, coordinateGrid(q));

            // just the regular sin function
            float y = sin(5.0 * q.x) * 2.0 - 1.0;

            ret = mix(ret, col1, plot(q, y, 0.1));
        }
        else if(r.y > 0.4) {
            vec2 q = (r - vec2(0.0, 0.6)) * vec2(1.0, 20.0);
            ret = mix(white, col1, coordinateGrid(q));

            // take the decimal part of the sin function
            float y = fract(sin(5.0 * q.x)) * 2.0 - 1.0;

            ret = mix(ret, col2, plot(q, y, 0.1));
        }
        else if(r.y > 0.1) {
            vec3 white = vec3(1.0);
            vec2 q = (r - vec2(0.0, 0.25)) * vec2(1.0, 20.0);
            ret = mix(white, gray, coordinateGrid(q));

            // scale up the outcome of the sine function
            // increase the scale and see the transition from
            // periodic pattern to chaotic pattern
            float scale = 10.0;
            float y = fract(sin(5.0 * q.x) * scale) * 2.0 - 1.0;

            ret = mix(ret, col1, plot(q, y, 0.2));
        }
        else if(r.y > -0.2) {
            vec3 white = vec3(1.0);
            vec2 q = (r - vec2(0.0, -0.0)) * vec2(1.0, 10.0);
            ret = mix(white, col1, coordinateGrid(q));

            float seed = q.x;
            // Scale up with a big real number
            float y = fract(sin(seed) * 43758.5453) * 2.0 - 1.0;
            // this can be used as a pseudo-random value
            // These type of function, functions in which two inputs
            // that are close to each other (such as close q.x positions)
            // return highly different output values, are called "hash"
            // function.

            ret = mix(ret, col2, plot(q, y, 0.1));
        }
        else {
            vec2 q = (r - vec2(0., -0.6));

            // use the loop index as the seed
            // and vary different quantities of disks, such as
            // location and radius
            for(float i = 0.0; i < 6.0; i++) {
                // change the seed and get different distributions
                float seed = i + 0.0;
                vec2 pos = (vec2(hash(seed), hash(seed + 0.5)) - 0.5) * 3.0;
                float radius = hash(seed + 3.5);
                pos *= vec2(1.0, 0.3);
                ret = mix(ret, col1, disk(q, pos, 0.2 * radius));
            }
        }

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
