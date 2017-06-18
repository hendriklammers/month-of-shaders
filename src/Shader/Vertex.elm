module Shader.Vertex exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


vertexShader : VertexShader
vertexShader =
    [glsl|

    precision mediump float;

    attribute vec2 position;
    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        gl_Position = vec4(position, 0.0, 1.0);
    }

    |]
