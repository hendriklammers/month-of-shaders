module Shader.Day3 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    const float PI = 3.14159265359;

    // rectangle that starts at bottom left
    float rect(vec2 p, vec2 pos, vec2 size) {
        vec2 bl = step(pos, p);
        // Subtracting from 1.0 to invert coordinates and the top right values
        vec2 tr = step(1.0 - pos - size, vec2(1.0 - p));
        return bl.x * bl.y * tr.x * tr.y;
    }

    void main () {
        // y: 0.0 to 1.0
        // x: 0.0 to xMax
        vec2 p = gl_FragCoord.xy / u_resolution.y;
        // Storing xMax so it can easily be used in positional functions
        float xMax = u_resolution.x / u_resolution.y;

        vec3 cBlue = vec3(0.016, 0.016, 0.627);
        vec3 cWhite = vec3(0.984, 0.988, 0.957);
        vec3 cGray = vec3(0.102, 0.078, 0.078);
        vec3 cBlack = vec3(0.008, 0.008, 0.0);
        vec3 cRed = vec3(0.969, 0.0, 0.016);
        vec3 cYellow = vec3(0.85, 0.85, 0.0);

        vec3 c = cWhite;
        // Increment animation speed
        float speed = u_time * 2.0;
        // Use Sine wave to animate x and y positions for certain elements
        float y1 = 0.3 + sin(speed) * 0.1;
        float x1 = xMax - 0.6 + sin(speed) * 0.1;

        // Colored rectangles
        c = mix(c, cRed, rect(p, vec2(x1, y1), vec2(xMax - x1, 1.0 - y1)));
        c = mix(c, cGray, rect(p, vec2(0.3, y1), vec2(0.2, 0.6 - y1)));
        c = mix(c, cBlue, rect(p, vec2(0.0, 0.0), vec2(0.3, y1)));

        // Black lines
        c = mix(c, cBlack, rect(p, vec2(0.0, 0.6), vec2(0.5, 0.03)));
        c = mix(c, cBlack, rect(p, vec2(0.3, 0.0), vec2(0.03, 1.0)));
        c = mix(c, cBlack, rect(p, vec2(0.5, 0.0), vec2(0.03, 1.0)));
        c = mix(c, cBlack, rect(p, vec2(0.0, y1), vec2(xMax, 0.03)));
        c = mix(c, cBlack, rect(p, vec2(x1, y1), vec2(0.03, 1.0 - y1)));

        gl_FragColor = vec4(c, 1.0);
    }

|]
