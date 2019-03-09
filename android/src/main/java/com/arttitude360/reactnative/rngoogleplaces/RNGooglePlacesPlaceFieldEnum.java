package com.arttitude360.reactnative.rngoogleplaces;

import android.util.SparseArray;
import android.support.annotation.Nullable;

import com.google.android.libraries.places.api.model.Place;

/**
 * Mapping between {@link com.google.android.libraries.places.api.model.Place.Field}'s class id and label, to fit with iOS functionality
 */
public enum RNGooglePlacesPlaceFieldEnum {
    ADDRESS(1, "formatted_address", Place.Field.ADDRESS),
    ID(2, "place_id", Place.Field.ID),
    LAT_LNG(3, "latlng", Place.Field.LAT_LNG),
    NAME(4, "name", Place.Field.NAME),
    OPENING_HOURS(5, "opening_hours", Place.Field.OPENING_HOURS),
    PHONE_NUMBER(6, "phone_number", Place.Field.PHONE_NUMBER),
    PHOTO_METADATAS(7, "photos", Place.Field.PHOTO_METADATAS),
    PLUS_CODE(8, "plus_code", Place.Field.PLUS_CODE),
    PRICE_LEVEL(9, "price_level", Place.Field.PRICE_LEVEL),
    RATING(10, "rating", Place.Field.RATING),
    TYPES(11, "type", Place.Field.TYPES),
    USER_RATINGS_TOTAL(12, "user_ratings_total", Place.Field.USER_RATINGS_TOTAL),
    VIEWPORT(13, "viewport", Place.Field.VIEWPORT),
    WEBSITE_URI(14, "website", Place.Field.WEBSITE_URI);

    private final String key;
    private final Place.Field field;

    private static class Indexer {
        private static SparseArray<RNGooglePlacesPlaceFieldEnum> index = new SparseArray<>();
    }

    RNGooglePlacesPlaceFieldEnum(int id, String key, Place.Field field) {
        this.key = key;
        this.field = field;
        Indexer.index.put(id, this);
    }

    public Place.Field getField() {
        return field;
    }
    
    @Nullable
    public static RNGooglePlacesPlaceFieldEnum findByFieldKey(String key) {
        int fieldId;

        switch (key) {
            case "formatted_address" : fieldId = 1; break;
            case "place_id" : fieldId = 2; break;
            case "latlng" : fieldId = 3; break;
            case "name" : fieldId = 4; break;
            case "opening_hours" : fieldId = 5; break;
            case "phone_number" : fieldId = 6; break;
            case "photos" : fieldId = 7; break;
            case "plus_code" : fieldId = 8; break;
            case "price_level" : fieldId = 9; break;
            case "rating" : fieldId = 10; break;
            case "type" : fieldId = 11; break;
            case "user_ratings_total" : fieldId = 12; break;
            case "viewport" : fieldId = 13; break;
            case "website" : fieldId = 14; break;
            default: fieldId = 15; break;
        }

        RNGooglePlacesPlaceFieldEnum fieldEnum = Indexer.index.get(fieldId);
        if (fieldEnum != null) return fieldEnum;
        return null;
    }
}
