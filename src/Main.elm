module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Html.Attributes
    exposing
        ( id
        , width
        , height
        , style
        , href
        , class
        , classList
        )
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Decode
import Math.Vector2 exposing (Vec2, vec2)
import Shader.Vertex exposing (vertexShader)
import Task
import Time exposing (Time)
import Types exposing (..)
import WebGL exposing (entity, triangles, toHtml, Mesh)
import Window exposing (Size)
import Keyboard
import Mouse exposing (Position)
import Shaders exposing (shaders)


-- MODEL


type alias Model =
    { size : Size
    , time : Time
    , activeShader : Maybe ShaderObject
    , shaders : List ShaderObject
    , animating : Bool
    , mouse : Position
    }


initialModel : Model
initialModel =
    { size = Size 0 0
    , time = 0
    , activeShader = List.head <| List.reverse shaders
    , shaders = shaders
    , animating = False
    , mouse = Position 0 0
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Task.perform WindowResize Window.size )



-- UPDATE


type Msg
    = WindowResize Size
    | TimeUpdate Time
    | ChangeShader Int
    | KeyPress Int
    | MouseMove Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize size ->
            ( { model | size = size }, Cmd.none )

        TimeUpdate time ->
            ( { model | time = model.time + time }, Cmd.none )

        ChangeShader index ->
            let
                active =
                    selectShader index model.shaders
            in
                ( { model | activeShader = active, time = 0 }, Cmd.none )

        KeyPress char ->
            if char == 32 then
                ( { model | animating = not model.animating }, Cmd.none )
            else
                model ! []

        -- TODO: Invert mouse position?
        MouseMove position ->
            ( { model | mouse = position }, Cmd.none )


selectShader : Int -> List ShaderObject -> Maybe ShaderObject
selectShader n shaders =
    List.head (List.drop n shaders)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes WindowResize
        , animationSubscription model.animating
        , Keyboard.presses (\keycode -> KeyPress keycode)
        , Mouse.moves MouseMove
        ]


animationSubscription : Bool -> Sub Msg
animationSubscription animating =
    if animating then
        AnimationFrame.diffs TimeUpdate
    else
        Sub.none



-- MESH


mesh : Mesh Vertex
mesh =
    triangles
        [ ( (Vertex (vec2 -1 1))
          , (Vertex (vec2 1 1))
          , (Vertex (vec2 -1 -1))
          )
        , ( (Vertex (vec2 -1 -1))
          , (Vertex (vec2 1 -1))
          , (Vertex (vec2 1 1))
          )
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ viewCanvas model
        , viewNavigation model
        , viewPause (not model.animating)
        ]


viewPause : Bool -> Html Msg
viewPause paused =
    if paused then
        div
            [ class "pause" ]
            [ span
                []
                [ text "Paused (Press SPACE to resume)" ]
            ]
    else
        text ""


isShaderActive : Maybe ShaderObject -> ShaderObject -> Bool
isShaderActive active current =
    case active of
        Just shader ->
            shader.id == current.id

        Nothing ->
            False


viewLink : Maybe ShaderObject -> Int -> ShaderObject -> Html Msg
viewLink active index shader =
    li [ class "navigation__item" ]
        [ viewTooltip shader.date
        , a
            [ href "#"
            , onLinkClick (ChangeShader index)
            , classList
                [ ( "navigation__link", True )
                , ( "navigation__link--active"
                  , isShaderActive active shader
                  )
                ]
            ]
            [ text (toString <| index + 1) ]
        ]


viewTooltip : String -> Html Msg
viewTooltip str =
    span
        [ class "tooltip" ]
        [ text str ]


viewNavigation : Model -> Html Msg
viewNavigation { shaders, activeShader } =
    nav [ class "navigation" ]
        [ ul []
            (List.indexedMap (viewLink activeShader) shaders)
        ]


onLinkClick : Msg -> Attribute Msg
onLinkClick msg =
    onWithOptions
        "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Decode.succeed msg)


viewCanvas : Model -> Html Msg
viewCanvas { size, time, activeShader, mouse } =
    case activeShader of
        Nothing ->
            text "No shader available"

        Just shader ->
            toHtml
                [ id "canvas"
                , width size.width
                , height size.height
                , style (canvasStyle size.width size.height)
                ]
                [ entity
                    vertexShader
                    shader.fragment
                    mesh
                    { u_resolution =
                        vec2
                            (toFloat size.width)
                            (toFloat size.height)
                    , u_time = time / 1000
                    , u_mouse =
                        vec2
                            (toFloat mouse.x)
                            -- Inverting mouse.y so it matches gl_FragCoord.y
                            (toFloat <| size.height - mouse.y)
                    }
                ]


canvasStyle : Int -> Int -> List ( String, String )
canvasStyle width height =
    [ ( "display", "block" )
    , ( "width", toString width ++ "px" )
    , ( "height", toString height ++ "px" )
    , ( "background", "#000" )
    ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
