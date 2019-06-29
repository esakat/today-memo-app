module Main exposing (Memo, Model, Msg(..), init, inputFormModal, main, update, view, viewTable, viewTr)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Modal as Modal
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


-- MODEL


type Msg
    = Add
    | CloseModal
    | ShowModal
    | UpdateTitle String
    | UpdateContent String
    | AddNewEntryClick
    | AddNewEntry Time.Posix
    | AdjustTimeZone Time.Zone

type alias Memo =
    { title : String
    , content : String
    , publishDate : String
    }


type alias Model =
    { memos : List Memo
    , modalVisibility : Modal.Visibility
    , title : String
    , content : String
    , now : String
    , zone : Time.Zone
    }


init :() -> (Model, Cmd Msg)
init _ =
    ({ memos =
        [ Memo "yeterday goood" "i have .." "2019/04/08"
        , Memo "We are happy" "I think so" "2019/03/05"
        , Memo "Sample" "Sample" "2018/02/05"
        ]
    , modalVisibility = Modal.hidden
    , title = ""
    , content = ""
    , now = ""
    , zone = Time.utc
    }, Task.perform AdjustTimeZone Time.here)



-- UPDATE

toDanishMonth : Time.Month -> String
toDanishMonth month =
  case month of
    Time.Jan -> "01"
    Time.Feb -> "02"
    Time.Mar -> "03"
    Time.Apr -> "04"
    Time.May -> "05"
    Time.Jun -> "06"
    Time.Jul -> "07"
    Time.Aug -> "08"
    Time.Sep -> "09"
    Time.Oct -> "10"
    Time.Nov -> "11"
    Time.Dec -> "12"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Add ->
            ({ model
                | memos = Memo model.title model.content "" :: model.memos
                , modalVisibility = Modal.hidden
                , title = ""
                , content = ""
            }, Cmd.none)

        CloseModal ->
            ({ model | modalVisibility = Modal.hidden }, Cmd.none)

        ShowModal ->
            ({ model | modalVisibility = Modal.shown }, Cmd.none)

        UpdateTitle t ->
            ({ model | title = t }, Cmd.none)

        UpdateContent c ->
            ({ model | content = c }, Cmd.none)

        AddNewEntryClick ->
            ( model, Task.perform AddNewEntry Time.now )
        AddNewEntry time ->
            let
                year = String.fromInt (Time.toYear  model.zone time)
                month =  toDanishMonth (Time.toMonth  model.zone time)
                day = String.fromInt (Time.toDay   model.zone time)
                -- hour = String.fromInt (Time.toHour   model.zone time)
                -- minute = String.fromInt (Time.toMinute   model.zone time)
            in
            ({ model
                | memos = Memo model.title model.content (year ++ "/" ++ month ++ "/" ++ day) :: model.memos
                , modalVisibility = Modal.hidden
                , title = ""
                , content = ""}
            , Cmd.none)

        AdjustTimeZone newZone ->
          ( { model | zone = newZone }
          , Cmd.none
          )


-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheet
        , viewTable model.memos
        , inputFormModal model
        ]


viewTable : List Memo -> Html Msg
viewTable memos =
    table []
        [ thead []
            [ th [] [ text "Title" ]
            , th [] [ text "Content" ]
            , th [] [ text "PublishDate" ]
            ]
        , tbody [] (List.map viewTr memos)
        ]


viewTr : Memo -> Html Msg
viewTr memo =
    tr []
        [ td [] [ text memo.title ]
        , td [] [ text memo.content ]
        , td [] [ text memo.publishDate ]
        ]


inputFormModal : Model -> Html Msg
inputFormModal model =
    div []
        [ Button.button
            [ Button.outlineSuccess
            , Button.attrs [ onClick <| ShowModal ]
            ]
            [ text "コンテンツを追加する" ]
        , Modal.config CloseModal
            |> Modal.large
            |> Modal.hideOnBackdropClick True
            |> Modal.h3 [] [ text "hoge" ]
            |> Modal.body []
                [ Form.group []
                    [ Form.label [ for "title" ] [ text "Title" ]
                    , Input.text
                        [ Input.onInput UpdateTitle
                        , Input.placeholder "title..."
                        ]
                    ]
                , Form.group []
                    [ Form.label [ for "textarea" ] [ text "Content" ]
                    , Textarea.textarea
                        [ Textarea.onInput UpdateContent
                        , Textarea.attrs [ placeholder "content..." ]
                        , Textarea.rows 5
                        , Textarea.id "content"
                        ]
                    ]
                ]
            |> Modal.footer []
                [ Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick CloseModal ]
                    ]
                    [ text "Close" ]
                , Button.button
                    [ Button.primary
                    , Button.attrs [ onClick AddNewEntryClick ]
                    ]
                    [ text "Submit" ]
                ]
            |> Modal.view model.modalVisibility
        ]
