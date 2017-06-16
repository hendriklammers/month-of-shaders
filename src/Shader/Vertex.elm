module Shader.Vertex exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


vertexShader : Shader Vertex Uniforms Varying
vertexShader =
    [glsl|

    precision mediump float;

    attribute vec2 position;
    uniform vec2 u_resolution;
    uniform float u_time;
    varying vec2 v_fragCoord; // Not used, can use gl_FragCoord instead?

    void main () {
        gl_Position = vec4(position, 0.0, 1.0);
        v_fragCoord = (position + 1.0) / 2.0 * u_resolution;
    }

    |]
