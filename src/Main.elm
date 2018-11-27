module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Builder
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


type Route
    = Topic String
    | Blog Int
    | UserRoute String
    | Comment String Int


type alias User =
    { id : Int
    , name : String
    , color : String
    , age : Int
    }



-- Parser is a type from Url.Parser.
-- type Parser a b
-- It takes a thing and returns a different thing.
-- string, int, and s are parsers.


routeParser : Parser (Route -> a) a
routeParser =
    -- Tries a bunch of parsers.
    -- oneOf : List (Parser a b) -> Parser a b
    oneOf
        [ map Topic (s "topic" </> string)
        , map Blog (s "blog" </> int)
        , map UserRoute (s "user" </> string)
        , map Comment (s "user" </> string </> s "comment" </> int)
        ]


testUrl =
    Url.fromString (Url.Builder.crossOrigin "http://foo.com" [ "topic", "foo" ] [])



-- Url.fromString "http://foo.com/topic/foo"


type alias Model =
    { key : Browser.Navigation.Key
    , message : String
    , route : Maybe Route
    , testUrl : Maybe Url.Url
    , users : List User
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , message = ""
      , route =
            case testUrl of
                Nothing ->
                    Nothing

                Just parsedUrl ->
                    Url.Parser.parse routeParser parsedUrl
      , testUrl = testUrl
      , users =
            [ { id = 0
              , name = "Jemma"
              , color = "pink"
              , age = 3
              }
            , { id = 1
              , name = "Samuel"
              , color = "blue"
              , age = 5
              }
            , { id = 2
              , name = "Amanda"
              , color = "orange"
              , age = 36
              }
            , { id = 3
              , name = "Jeremy"
              , color = "green"
              , age = 36
              }
            ]
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
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        UrlChanged url ->
            ( { model | message = Url.toString url }, Cmd.none )


viewLink : String -> Html Msg
viewLink path =
    div []
        [ a [ href path ] [ text path ]
        ]


viewRoute : Maybe Route -> Html Msg
viewRoute route =
    case route of
        Nothing ->
            div [] [ text "route?" ]

        Just theRoute ->
            case theRoute of
                Topic val ->
                    div [] [ text ("topic: " ++ val) ]

                Blog val ->
                    div [] [ text ("blog: " ++ String.fromInt val) ]

                UserRoute val ->
                    div [] [ text ("user: " ++ val) ]

                Comment user comment ->
                    div [] [ text ("comment: " ++ user ++ String.fromInt comment) ]


viewUserLink : User -> Html Msg
viewUserLink user =
    li []
        [ a
            [ href
                (Url.Builder.relative [ user.name ] [])
            ]
            [ text user.name ]
        ]


viewNav : List User -> Html Msg
viewNav users =
    ul [] (List.map viewUserLink users)


view : Model -> Browser.Document Msg
view model =
    { title = model.message
    , body =
        [ div [] [ text model.message ]
        , viewRoute model.route
        , viewLink "#home"
        , viewLink "#home/gingo"
        , viewLink "https://google.com"
        , viewNav model.users
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
