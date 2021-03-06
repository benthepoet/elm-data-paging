import Browser
import Html
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode
import Maybe
import Result
import String
import Pure

main = 
    Browser.sandbox 
        { init = initialModel
        , update = update
        , view = view 
        }


type alias Model = 
    { perPage: Int
    , page: Int
    , pageSizes: List String
    , headers: List String
    , data: List (List String)
    }


type Msg 
    = Previous 
    | Next 
    | Page Int 
    | PerPage Int


initialModel : Model
initialModel = 
    { perPage = 2
    , page = 1
    , pageSizes =
        [ "2"
        , "5"
        ]
    , headers = 
        [ "Id"
        , "Color"
        , "Size"
        ]
    , data = 
        [ ["1", "Blue", "Small"]
        , ["2", "Red", "Large"]
        , ["3", "Yellow", "Small"]
        , ["4", "Green", "Medium"]
        , ["5", "Orange", "Large"]
        , ["6", "Purple", "Small"]
        , ["7", "Blue", "Large"]
        ]
    }


pageCount perPage data = 
    let
        count = data |> List.length |> toFloat
    in
        ceiling (count / (toFloat perPage))


pageData model = 
    let
        offset = (model.page - 1) * model.perPage
        perPage = model.perPage
    in
        model.data
            |> List.drop offset
            |> List.take perPage
        

update msg model =
    case msg of
        Previous ->
            { model | page = model.page - 1 }
        Next ->
            { model | page = model.page + 1 }
        Page n ->
            { model | page = n }
        PerPage n ->
            let
                count = pageCount n model.data 
            in
                { model | 
                    perPage = n,
                    page = if model.page >= count then count else model.page
                }


renderButtons model = 
    [ Html.button 
        [ Html.Attributes.classList 
            [ (Pure.button, True)
            , ("prev-button", True)
            ]
        , Html.Attributes.disabled (model.page <= 1)
        , onClick Previous
        ] [ Html.text "Previous" ]
    , renderPageButtons (pageCount model.perPage model.data) model.page
    , Html.button 
        [ Html.Attributes.classList 
            [ (Pure.button, True)
            , ("next-button", True)
            ]
        , Html.Attributes.disabled (model.page >= (pageCount model.perPage model.data))
        , onClick Next
        ] [ Html.text "Next"]
    ]


renderListItem item = 
    Html.tr [] 
        (List.map (\x -> Html.td [] [ Html.text x ]) item)


renderListItems model = 
    model
        |> pageData
        |> List.map renderListItem
    

renderListHeaders headers = 
    Html.tr []
        (List.map (\x -> Html.th [] [ Html.text x ]) headers)
    

renderPageButton page active = 
    Html.button 
        [ Html.Attributes.class Pure.button
        , Html.Attributes.disabled (page == active)
        , Html.Events.onClick (Page page)
        ] 
        [ Html.text (Debug.toString page) ]
    

renderPageButtons count active = 
    Html.span []
        (List.map (\p -> renderPageButton p active) <| List.range 1 count)


view model = 
    Html.div [Html.Attributes.class Pure.grid]
        [ Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] []
        , Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] 
            [ Html.h2 [] [Html.text "Practical Elm - Data Paging"]
            , Html.div [] (renderButtons model)
            , Html.div []
                [ Html.select [Html.Events.on "change" (Json.Decode.map (\s -> PerPage (s |> String.toInt |> Maybe.withDefault 2)) Html.Events.targetValue)] 
                    (List.map (\s -> Html.option [] [Html.text s]) model.pageSizes)
                ]
            , Html.table 
                [ Html.Attributes.classList 
                    [ (Pure.table, True)
                    , (Pure.tableStriped, True)
                    ]
                ] 
                [ Html.thead [] [renderListHeaders model.headers]
                , Html.tbody [] (renderListItems model)
                ]
            ]
        , Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] []    
        ]