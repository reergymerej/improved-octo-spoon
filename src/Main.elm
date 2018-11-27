module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , message : String
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , message = ""
      }
    , Cmd.none
    )


onUrlChange : Url.Url -> Msg
onUrlChange url =
    UrlChanged url



{-
   type UrlRequest
     = Internal Url.Url
     | External String
-}


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest req =
    LinkClicked req


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( { model
                        | message = "internal"
                      }
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        UrlChanged url ->
            ( model, Cmd.none )


viewLink : String -> Html Msg
viewLink path =
    div []
        [ a [ href path ] [ text path ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Hello!"
    , body =
        [ div [] [ text model.message ]
        , viewLink "/home"
        , viewLink "/home/gingo"
        , viewLink "https://google.com"
        ]
    }


main =
    Browser.application
        { init = init
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
