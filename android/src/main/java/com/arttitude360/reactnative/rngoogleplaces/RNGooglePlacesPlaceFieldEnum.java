package com.arttitude360.reactnative.rngoogleplaces;

import android.util.SparseArray;
import android.support.annotation.Nullable;

import com.google.android.libraries.places.api.model.Place;

/**
 * Mapping between {@link com.google.android.libraries.places.api.model.Place.Field}'s class id and label, to fit with iOS functionality
 */
public enum RNGooglePlacesPlaceFieldEnum {
    ADDRESS(1, "address", Place.Field.ADDRESS),
    ID(2, "placeID", Place.Field.ID),
    LAT_LNG(3, "location", Place.Field.LAT_LNG),
    NAME(4, "name", Place.Field.NAME),
    OPENING_HOURS(5, "openingHours", Place.Field.OPENING_HOURS),
    PHONE_NUMBER(6, "phoneNumber", Place.Field.PHONE_NUMBER),
    PHOTO_METADATAS(7, "photos", Place.Field.PHOTO_METADATAS),
    PLUS_CODE(8, "plusCode", Place.Field.PLUS_CODE),
    PRICE_LEVEL(9, "priceLevel", Place.Field.PRICE_LEVEL),
    RATING(10, "rating", Place.Field.RATING),
    TYPES(11, "types", Place.Field.TYPES),
    USER_RATINGS_TOTAL(12, "userRatingsTotal", Place.Field.USER_RATINGS_TOTAL),
    VIEWPORT(13, "viewport", Place.Field.VIEWPORT),
    WEBSITE_URI(14, "website", Place.Field.WEBSITE_URI),
    ADDRESS_COMPONENTS(15, "addressComponents", Place.Field.ADDRESS_COMPONENTS);

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
            case "address" : fieldId = 1; break;
            case "placeID" : fieldId = 2; break;
            case "location" : fieldId = 3; break;
            case "name" : fieldId = 4; break;
            case "openingHours" : fieldId = 5; break;
            case "phoneNumber" : fieldId = 6; break;
            case "photos" : fieldId = 7; break;
            case "plusCode" : fieldId = 8; break;
            case "priceLevel" : fieldId = 9; break;
            case "rating" : fieldId = 10; break;
            case "types" : fieldId = 11; break;
            case "userRatingsTotal" : fieldId = 12; break;
            case "viewport" : fieldId = 13; break;
            case "website" : fieldId = 14; break;
            case "addressComponents" : fieldId = 15; break;
            default: fieldId = 16; break;
        }

        RNGooglePlacesPlaceFieldEnum fieldEnum = Indexer.index.get(fieldId);
        if (fieldEnum != null) return fieldEnum;
        return null;
    }
}
