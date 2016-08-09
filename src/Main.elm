import Html
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Pure

main = 
    beginnerProgram 
        { model = model
        , update = update
        , view = view 
        }


type alias Model = 
    { perPage: Int
    , page: Int
    , headers: List String
    , data: List (List String)
    }


model : Model
model = 
    { perPage = 2
    , page = 1
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
    
pageCount model = 
    let
        count = toFloat (List.length model.data)
        perPage = toFloat model.perPage
    in
        ceiling (count / perPage)
    
pageData model = 
    let
        offset = (model.page - 1) * model.perPage
        limit = model.perPage
    in
        model.data
            |> List.drop offset
            |> List.take limit
        
type Msg = Previous | Next | Page Int
    
update msg model =
    case msg of
        Previous ->
            { model | page = model.page - 1 }
        Next ->
            { model | page = model.page + 1 }
        Page n ->
            { model | page = n }

renderButtons model = 
    [ Html.button 
        [ Html.Attributes.classList 
            [ (Pure.button, True)
            , ("prev-button", True)
            ]
        , Html.Attributes.disabled (model.page <= 1)
        , onClick Previous
        ] [Html.text "Previous"]
    , renderPageButtons (pageCount model) model.page
    , Html.button 
        [ Html.Attributes.classList 
            [ (Pure.button, True)
            , ("next-button", True)
            ]
        , Html.Attributes.disabled (model.page >= (pageCount model))
        , onClick Next
        ] [ Html.text "Next"]
    ]
        
renderListItem item = 
    Html.tr [] 
        (List.map (\x -> Html.td [] [Html.text x]) item)

renderListItems model = 
    List.map renderListItem (pageData model)
    
renderListHeaders headers = 
    Html.tr []
        (List.map (\x -> Html.th [] [Html.text x]) headers)
    
renderPageButton page active = 
    Html.button 
        [ Html.Attributes.class Pure.button
        , Html.Attributes.disabled (page == active)
        , Html.Events.onClick (Page page)]
        [Html.text (toString page)]
    
renderPageButtons count active = 
    Html.span []
        (List.map (\p -> renderPageButton p active) [1..count])
    
view model = 
    Html.div [Html.Attributes.class Pure.grid]
        [ Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] []
        , Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] 
            [ Html.h2 [] [Html.text "Practical Elm - Data Paging"]
            , Html.div [] (renderButtons model)
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