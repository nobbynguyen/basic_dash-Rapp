library(dash)
#library(dashCoreComponents)
#library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

df <- readr::read_csv(here::here('data', 'netflix_movies_genres.csv'))
movie_genres <- unique(df[['genre']])


app$layout(
    div(
        list(
            h1('Movie Rating'),
            dccGraph(id='rating_bar_chart'),
            dccDropdown(
                id='col-select',
                options = movie_genres,
                value='Dramas')
        )
    )
)

app$callback(
    output('rating_bar_chart', 'figure'),
    list(input('col-select', 'value')),
    function(selected_genre) {
        plot_rating <- ggplot(df %>% filter(genre==selected_genre)) +
            aes(y = rating,
            fill = 'magenta') +
            geom_bar(stat='count', show.legend=FALSE) +
            labs(x='Number of movies', y='Rating')
        ggplotly(plot_rating) %>% layout()
    }
)


app$run_server(host = '0.0.0.0')
