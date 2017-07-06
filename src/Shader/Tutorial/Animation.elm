module Shader.Tutorial.Animation exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    // a function that draws an (anti-aliased) grid of coordinate system
    float coordinateGrid(vec2 r) {
        vec3 axesCol = vec3(0.0, 0.0, 1.0);
        vec3 gridCol = vec3(0.5);
        float ret = 0.0;

        // Draw grid lines
        const float tickWidth = 0.1;
        for(float i = -2.0; i < 2.0; i += tickWidth) {
            // "i" is the line coordinate.
            ret += 1.0 - smoothstep(0.0, 0.002, abs(r.x - i));
            ret += 1.0 - smoothstep(0.0, 0.002, abs(r.y - i));
        }

        // Draw the axes
        ret += 1.0 - smoothstep(0.001, 0.015, abs(r.x));
        ret += 1.0 - smoothstep(0.001, 0.015, abs(r.y));
        return ret;
    }

    // returns 1.0 if inside circle
    float disk(vec2 r, vec2 center, float radius) {
        return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
    }

    // returns 1.0 if inside the rectangle
    float rectangle(vec2 r, vec2 topLeft, vec2 bottomRight) {
        float ret;
        float d = 0.005;
        ret = smoothstep(topLeft.x - d, topLeft.x + d, r.x);
        ret *= smoothstep(topLeft.y - d, topLeft.y + d, r.y);
        ret *= 1.0 - smoothstep(bottomRight.y - d, bottomRight.y + d, r.y);
        ret *= 1.0 - smoothstep(bottomRight.x - d, bottomRight.x + d, r.x);
        return ret;
    }

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        float xMax = u_resolution.x / u_resolution.y;

        vec3 bgCol = vec3(1.0);
        vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
        vec3 col2 = vec3(1.00, 0.329, 0.298); // yellow
        vec3 col3 = vec3(0.867, 0.910, 0.247); // red
        vec3 ret;

        if (p.x < 1.0 / 5.0) {
            vec2 q = r + vec2(xMax * 4.0 / 5.0, 0.0);
            ret = vec3(0.2);

            float y = u_time;
            // mod constraints y to be between 0.0 and 2.0,
            // and y jumps from 2.0 to 0.0
            // substracting -1.0 makes why jump from 1.0 to -1.0
            y = mod(y, 2.0) - 1.0;

            ret = mix(ret, col1, disk(q, vec2(0.0, y), 0.1));
        } else if (p.x < 2.0 / 5.0) {
            vec2 q = r + vec2(xMax * 2.0 / 5.0, 0.0);
            ret = vec3(0.3);
            // oscillation
            float amplitude = 0.8;
            // y coordinate oscillates with a period of 0.5 seconds
            float y = 0.8 * sin(0.5 * u_time * twopi);
            // radius oscillates too
            float radius = 0.15 + 0.05 * sin(u_time * 8.0);
            ret = mix(ret, col1, disk(q, vec2(0.0, y), radius) );
        } else if (p.x < 3.0 / 5.0) {
            vec2 q = r + vec2(xMax * 0.0 / 5.0, 0.0);
            ret = vec3(0.4);
            // booth coordinates oscillates
            float x = 0.2 * cos(u_time * 5.0);
            // but they have a phase difference of pi / 2
            float y = 0.3 * cos(u_time * 5.0 + pi / 2.0);
            float radius = 0.2 + 0.1 * sin(u_time * 2.0);
            // make the color mixture time dependent
            vec3 color = mix(col1, col2, sin(u_time) * 0.5 + 0.5);
            ret = mix(ret, color, rectangle(q, vec2(x - 0.1, y - 0.1), vec2(x + 0.1, y + 0.1)));
            // try different phases, different amplitudes and different frequencies
            // for x and y coordinates
        } else if (p.x < 4.0 / 5.0) {
            vec2 q = r + vec2(-xMax * 2.0 / 5.0, 0.0);
            ret = vec3(0.3);

            for(float i = -1.0; i < 1.0; i += 0.2) {
                float x = 0.2 * cos(u_time * 5.0 + i * pi);
                // y coordinate is the loop value
                float y = i;
                vec2 s = q - vec2(x, y);
                // each box has a different phase
                float angle = u_time * 3.0 + i;
                mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
                s = rot * s;
                ret = mix(ret, col1, rectangle(s, vec2(-0.06, -0.06), vec2(0.06, 0.06)));
            }
        } else {
            vec2 q = r + vec2(-xMax * 4.0 / 5.0, 0.0);
            ret = vec3(0.2);

            float speed = 2.0;
            float t = u_time * speed;
            float stopEveryAngle = pi / 2.0;
            float stopRatio = 0.5;
            float t1 = (floor(t) + smoothstep(0.0, 1.0 - stopRatio, fract(t))) * stopEveryAngle;

            float x = -0.2 * cos(t1);
            float y = 0.3 * sin(t1);
            float dx = 0.1 + 0.03 * sin(t * 10.0);
            float dy = 0.1 + 0.03 * sin(t * 10.0 + pi);
            ret = mix(ret, col1, rectangle(q, vec2(x - dx, y - dy), vec2(x + dx, y + dy)));
        }

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
