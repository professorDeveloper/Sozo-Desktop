

// --- Banner Query ---
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

// --- Recommendations Query ---
const String reccomendationQuery = '''query getRecommendations {
  Page(page: 1, perPage: 30) {
    media(sort: SCORE_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      coverImage {
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

// --- Trending Query ---
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
      coverImage {
        large
        medium
        extraLarge
      }
    }
  }
}
''';

// --- Most Favourite Query ---
const String mostFavouriteQuery = '''query getPopular {
  Page(page: 1, perPage: 30) {
    media(sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
      id
      format
      episodes
      genres
      season
      seasonYear
      coverImage {
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

// --- Search Query ---
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

const String getGenres = '''{ GenreCollection }''';

// --- Anime Detail Query ---
const String getAnimeByIdQuery = '''query getAnimeById(\$id: Int) {
  Media(id: \$id) {
    id
    idMal
    episodes
    countryOfOrigin
    isAdult
    trailer {
      site
      thumbnail
    }
    title {
      english
    }
    seasonYear
    coverImage {
      large
      extraLarge
    }
    bannerImage
    countryOfOrigin
    externalLinks {
      site
      url
    }
    hashtag
    airingSchedule {
      nodes {
        airingAt
        timeUntilAiring
        episode
      }
    }
    staff {
      nodes {
        image {
          medium
        }
        name {
          userPreferred
        }
      }
    }
    studios {
      nodes {
        name
      }
    }
    episodes
    externalLinks {
      url
    }
    source
    meanScore
    averageScore
    genres
    description
  }
}
''';


// --- Characters by Anime ID ---
const String getCharactersAnimeByIdQuery = '''query getCharactersAnimeById(\$id: Int) {
  Media(id: \$id) {
    characters {
      nodes {
        id
        name {
          userPreferred
          middle
        }
        age
        image {
          medium
        }
      }
    }
  }
}
''';

// --- Character Detail Query ---
const String getCharacterDetailQuery = '''query getCharacterDetail(\$id: Int) {
  Character(id: \$id) {
    favourites
    isFavourite
    age
    name {
      userPreferred
      middle
      alternative
    }
    gender
    image {
      medium
    }
    media {
      nodes {
        id
        title {
          userPreferred
        }
        studios {
          nodes {
            name
          }
        }
        coverImage {
          large
        }
        mediaListEntry {
          status
        }
        genres
        hashtag
        meanScore
        averageScore
      }
    }
  }
}
''';

// --- Relations Query ---
const String getRelationsByIdQuery = '''query getRelationsById(\$page: Int) {
  Page(page: \$page, perPage: 7) {
    mediaTrends {
      media {
        id
        title {
        english
        userPreferred
        }
        studios {
          nodes {
            name
          }
        }
        genres
        format
        coverImage {
        large
        medium
        extraLarge
      }
        mediaListEntry {
          status
        }
        genres
        hashtag
        meanScore
        averageScore
      }
    }
  }
}
''';

