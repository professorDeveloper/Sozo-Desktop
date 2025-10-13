// Step 3: Define your GraphQL query
const String bannerQuery = '''query getBanner {
  Page(page: 1, perPage: 9) {
    media(sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      season
      seasonYear
      title {
        english
      }
      bannerImage
      description
    }
  }
}
''';
const String reccomendationQuery = '''query getRecommendations {
  Page(page: 1, perPage: 30) {
    media(sort: SCORE_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      coverImage{
          large
          medium
          extraLarge
        }
      season
      seasonYear
      title {
        english
      }
      bannerImage
      description
    }
  }
}
''';
const String trendingQuery = '''query getTrending {
  Page(page: 1, perPage: 30) {
    media(sort: TRENDING_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      season
      seasonYear
      title {
        english
      }
      bannerImage
      description
      coverImage{
          large
          medium
          extraLarge
        }
    }
  }
}

''';
const String mostFavouriteQuery = '''query getPopular {
  Page(page: 1, perPage: 30) {
    media(sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      season
      seasonYear
      coverImage{
          large
          medium
          extraLarge
        }
      title {
        english
      }
      bannerImage
      description
    }
  }
}
''';

const String searchQuery = '''
query searchAnime(\$search: String) {
  Page(page: 1, perPage: 20) {
    media(search: \$search, type: ANIME, sort: POPULARITY_DESC) {
      id
      format
      episodes
      genres
      season
      seasonYear
      title {
        english
        romaji
        native
      }
      coverImage {
        large
        medium
        extraLarge
      }
      bannerImage
      description
      averageScore
      studios {
        nodes {
          name
        }
      }
    }
  }
}
''';
const String getGenres='''{GenreCollection}''';