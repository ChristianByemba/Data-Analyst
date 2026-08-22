# Raw data

Not committed (excluded via `.gitignore`). To reproduce:

```python
import kagglehub
path = kagglehub.dataset_download("rounakbanik/the-movies-dataset")
```

Or download manually from [Kaggle](https://www.kaggle.com/rounakbanik/the-movies-dataset).

## Files kept

Only the files relevant to this project's business task (movie-level financial return and
audience rating) are kept in `data/raw/`:

- `movies_metadata.csv` — budget, revenue, genres, runtime, release date, vote average/count
- `credits.csv` — cast & crew
- `keywords.csv` — plot keywords
- `links_small.csv` — a ~9,000-movie ID crosswalk to MovieLens/IMDB
- `ratings_small.csv` — a 100,000-rating sample of user ratings

**Not kept**: the full `ratings.csv` (677 MB — user-level MovieLens ratings for the entire
catalog) and the full `links.csv`. Neither is needed for a movie-level financial/rating analysis;
`ratings_small.csv` and `movies_metadata.csv`'s own `vote_average`/`vote_count` cover the need.

## License

CC0: Public Domain, made available by Rounak Banik (sourced from TMDB and GroupLens/MovieLens).
