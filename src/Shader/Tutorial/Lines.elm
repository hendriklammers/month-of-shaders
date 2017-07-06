module Shader.Tutorial.Lines exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        //vec2 r = vec2(gl_FragCoord.x / u_resolution.x, gl_FragCoord.y / u_resolution.y);
        vec2 r = vec2(gl_FragCoord.xy / u_resolution.xy);

        vec3 bgColor = vec3(1.0);
        vec3 color1 = vec3(0.216, 0.471, 0.698);
        vec3 color2 = vec3(1.00, 0.329, 0.298);
        vec3 color3 = vec3(0.867, 0.910, 0.247);

        vec3 pixel = bgColor;

        float leftCoord = 0.54;
        float rightCoord = 0.55;
        if( r.x < rightCoord && r.x > leftCoord ) pixel = color1;

        // a different way of expressing a vertical line
        // in terms of its x-coordinate and its thickness:
        float lineCoordinate = 0.3;
        float lineThickness = 0.01; // The actual thickness will be twice this value
        if (abs(r.x - lineCoordinate) < lineThickness) {
            pixel = color2;
        }

        // Horizontal line
        if (abs(r.y - 0.5) < 0.02) {
            pixel = color3;
        }

        vec3 axesColor = vec3(0.0, 0.0, 1.0);
        vec3 gridColor = vec3(0.5);

        // Draw grid
        const float tickWidth = 0.1;
        for (float i = 0.0; i < 1.0; i += tickWidth) {
            if (abs(r.x - i) < 0.001) {
                pixel = gridColor;
            }
            if (abs(r.y - i) < 0.001) {
                pixel = gridColor;
            }
        }

        // Draw the axes
        if( abs(r.x)<0.005 ) pixel = axesColor;
        if( abs(r.y)<0.006 ) pixel = axesColor;

        gl_FragColor = vec4(pixel, 1.0);
    }

|]
