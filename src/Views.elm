module Views exposing (..)

-- External Imports

import Html exposing (..)
import Html.Attributes exposing (..)


-- Internal Imports

import Types exposing (..)
import Utils.Types exposing (ApiResponse(..))
import Translators exposing (alertTranslator, silenceTranslator)
import Silences.Views
import Silences.Types
import Alerts.Views


view : Model -> Html Msg
view model =
    case model.route of
        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                    Html.map alertTranslator (Alerts.Views.view route alertGroups)

                Loading ->
                    loading

                _ ->
                    notFoundView model

        NewSilenceRoute ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Html.map Silences.Types.ForSelf (Silences.Views.silenceForm "New" silence))

                Loading ->
                    loading

                _ ->
                    notFoundView model

        EditSilenceRoute id ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Html.map Silences.Types.ForSelf (Silences.Views.silenceForm "Edit" silence))

                Loading ->
                    loading

                _ ->
                    notFoundView model

        SilencesRoute ->
            -- Add buttons at the top to filter Active/Pending/Expired
            case model.silences of
                Success silences ->
                    Html.map silenceTranslator (apiDataList Silences.Views.silenceList silences)

                Loading ->
                    loading

                _ ->
                    notFoundView model

        SilenceRoute name ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Silences.Views.silence silence)

                Loading ->
                    loading

                _ ->
                    notFoundView model

        _ ->
            notFoundView model


loading : Html msg
loading =
    div []
        [ i [ class "fa fa-cog fa-spin fa-3x fa-fw" ] []
        , span [ class "sr-only" ] [ text "Loading..." ]
        ]


todoView : a -> Html Msg
todoView model =
    div []
        [ h1 [] [ text "todo" ]
        ]


notFoundView : a -> Html msg
notFoundView model =
    div []
        [ h1 [] [ text "not found" ]
        ]


apiDataList : (a -> Html msg) -> List a -> Html msg
apiDataList fn list =
    ul
        [ classList
            [ ( "list", True )
            , ( "pa0", True )
            ]
        ]
        (List.map fn list)
