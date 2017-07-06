module Shader.Tutorial.Transformations exposing (..)

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

        vec3 ret = bgCol;

        float angle = 0.6;
        mat2 rotationMatrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

        if (p.x < 0.5) {
            // put the origin at the center of Part I
            r = r - vec2(-xMax / 2.0, 0.0);

            vec2 rotated = rotationMatrix * r;
            vec2 rotatedTranslated = rotated - vec2(0.4, 0.5);

            ret = mix(ret, col1, coordinateGrid(r) * 0.3);
            ret = mix(ret, col2, coordinateGrid(rotated) * 0.3);
            ret = mix(ret, col3, coordinateGrid(rotatedTranslated) * 0.3);

            ret = mix(ret, col1, rectangle(r, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
            ret = mix(ret, col2, rectangle(rotated, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
            ret = mix(ret, col3, rectangle(rotatedTranslated, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
        } else {
            r = r - vec2(xMax * 0.5, 0.0);

            vec2 translated = r - vec2(0.4, 0.5);
            vec2 translatedRotated = rotationMatrix * translated;

            ret = mix(ret, col1, coordinateGrid(r) * 0.3);
            ret = mix(ret, col2, coordinateGrid(translated) * 0.3);
            ret = mix(ret, col3, coordinateGrid(translatedRotated) * 0.3);

            ret = mix(ret, col1, rectangle(r, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
            ret = mix(ret, col2, rectangle(translated, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
            ret = mix(ret, col3, rectangle(translatedRotated, vec2(-0.1, -0.2), vec2(0.1, 0.2)));
        }

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
