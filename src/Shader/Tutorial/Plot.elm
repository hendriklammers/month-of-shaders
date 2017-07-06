module Shader.Tutorial.Plot exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    float linearstep(float edge0, float edge1, float x) {
        float t = (x - edge0) / (edge1 - edge0);
        return clamp(t, 0.0, 1.0);
    }

    float smootherstep(float edge0, float edge1, float x) {
        float t = (x - edge0) / (edge1 - edge0);
        float t1 = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
        return clamp(t1, 0.0, 1.0);
    }

    void plot(vec2 r, float y, float lineThickness, vec3 color, inout vec3 pixel) {
        if(abs(y - r.y) < lineThickness ) {
            pixel = color;
        }
    }

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        float xMax = u_resolution.x / u_resolution.y;

        vec3 bgCol = vec3(1.0);
        vec3 axesCol = vec3(0.0, 0.0, 1.0);
        vec3 gridCol = vec3(0.5);
        vec3 col1 = vec3(0.841, 0.582, 0.594);
        vec3 col2 = vec3(0.884, 0.850, 0.648);
        vec3 col3 = vec3(0.348, 0.555, 0.641);

        vec3 pixel = bgCol;

        // Draw grid lines
        const float tickWidth = 0.1;
        for(float i = -2.0; i < 2.0; i += tickWidth) {
            // "i" is the line coordinate.
            if(abs(r.x - i) < 0.004) pixel = gridCol;
            if(abs(r.y - i) < 0.004) pixel = gridCol;
        }
        // Draw the axes
        if( abs(r.x)<0.006 ) pixel = axesCol;
        if( abs(r.y)<0.007 ) pixel = axesCol;

        // Draw functions
        float x = r.x;
        float y = r.y;
        // pink functions
        // y = 2*x + 5
        if( abs(2.*x + .5 - y) < 0.02 ) pixel = col1;
        // y = x^2 - .2
        if( abs(r.x*r.x-0.2 - y) < 0.01 ) pixel = col1;
        // y = sin(pi x)
        if( abs(sin(pi*r.x) - y) < 0.02 ) pixel = col1;

        // blue functions, the step function variations
        // (functions are scaled and translated vertically)
        if( abs(0.25*step(0.0, x)+0.6 - y) < 0.01 ) pixel = col3;
        if( abs(0.25*linearstep(-0.5, 0.5, x)+0.1 - y) < 0.01 ) pixel = col3;
        if( abs(0.25*smoothstep(-0.5, 0.5, x)-0.4 - y) < 0.01 ) pixel = col3;
        if( abs(0.25*smootherstep(-0.5, 0.5, x)-0.9 - y) < 0.01 ) pixel = col3;

        // yellow functions
        // have a function that plots functions :-)
        plot(r, 0.5*clamp(sin(twopi * x), 0.0, 1.0)-0.7, 0.015, col2, pixel);
        // bell curve around -0.5
        plot(r, 0.6*exp(-10.0*(x+0.8)*(x+0.8)) - 0.1, 0.015, col2, pixel);

        gl_FragColor = vec4(pixel, 1.0);
    }

|]
