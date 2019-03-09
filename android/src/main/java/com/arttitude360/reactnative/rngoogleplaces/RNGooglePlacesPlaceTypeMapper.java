package com.arttitude360.reactnative.rngoogleplaces;

import com.google.android.libraries.places.api.model.Place;

final class RNGooglePlacesPlaceTypeMapper {

    static String getTypeSlug(Place.Type type) {
        String slug;

        switch (type) {
            case ACCOUNTING:
                slug = "accounting";
                break;
            case ADMINISTRATIVE_AREA_LEVEL_1:
                slug = "administrative_area_level_1";
                break;
            case ADMINISTRATIVE_AREA_LEVEL_2:
                slug = "administrative_area_level_2";
                break;
            case ADMINISTRATIVE_AREA_LEVEL_3:
                slug = "administrative_area_level_3";
                break;
            case ADMINISTRATIVE_AREA_LEVEL_4:
                slug = "administrative_area_level_4";
                break;
            case ADMINISTRATIVE_AREA_LEVEL_5:
                slug = "administrative_area_level_5";
                break;
            case AIRPORT:
                slug = "airport";
                break;
            case AMUSEMENT_PARK:
                slug = "amusement_park";
                break;
            case AQUARIUM:
                slug = "aquarium";
                break;
            case ART_GALLERY:
                slug = "art_gallery";
                break;
            case ATM:
                slug = "atm";
                break;
            case BAKERY:
                slug = "bakery";
                break;
            case BANK:
                slug = "bank";
                break;
            case BAR:
                slug = "bar";
                break;
            case BEAUTY_SALON:
                slug = "beauty_salon";
                break;
            case BICYCLE_STORE:
                slug = "bicycle_store";
                break;
            case BOOK_STORE:
                slug = "book_store";
                break;
            case BOWLING_ALLEY:
                slug = "bowling_alley";
                break;
            case BUS_STATION:
                slug = "bus_station";
                break;
            case CAFE:
                slug = "cafe";
                break;
            case CAMPGROUND:
                slug = "campground";
                break;
            case CAR_DEALER:
                slug = "car_dealer";
                break;
            case CAR_RENTAL:
                slug = "car_rental";
                break;
            case CAR_REPAIR:
                slug = "car_repair";
                break;
            case CAR_WASH:
                slug = "car_wash";
                break;
            case CASINO:
                slug = "casino";
                break;
            case CEMETERY:
                slug = "cemetery";
                break;
            case CHURCH:
                slug = "church";
                break;
            case CITY_HALL:
                slug = "city_hall";
                break;
            case CLOTHING_STORE:
                slug = "clothing_store";
                break;
            case COLLOQUIAL_AREA:
                slug = "colloquial_area";
                break;
            case CONVENIENCE_STORE:
                slug = "convenience_store";
                break;
            case COUNTRY:
                slug = "country";
                break;
            case COURTHOUSE:
                slug = "courthouse";
                break;
            case DENTIST:
                slug = "dentist";
                break;
            case DEPARTMENT_STORE:
                slug = "department_store";
                break;
            case DOCTOR:
                slug = "doctor";
                break;
            case ELECTRICIAN:
                slug = "electrician";
                break;
            case ELECTRONICS_STORE:
                slug = "electronics_store";
                break;
            case EMBASSY:
                slug = "embassy";
                break;
            case ESTABLISHMENT:
                slug = "establishment";
                break;
            case FINANCE:
                slug = "finance";
                break;
            case FIRE_STATION:
                slug = "fire_station";
                break;
            case FLOOR:
                slug = "floor";
                break;
            case FLORIST:
                slug = "florist";
                break;
            case FOOD:
                slug = "food";
                break;
            case FUNERAL_HOME:
                slug = "funeral_home";
                break;
            case FURNITURE_STORE:
                slug = "furniture_store";
                break;
            case GAS_STATION:
                slug = "gas_station";
                break;
            case GENERAL_CONTRACTOR:
                slug = "general_contractor";
                break;
            case GEOCODE:
                slug = "geocode";
                break;
            case GROCERY_OR_SUPERMARKET:
                slug = "grocery_or_supermarket";
                break;
            case GYM:
                slug = "gym";
                break;
            case HAIR_CARE:
                slug = "hair_care";
                break;
            case HARDWARE_STORE:
                slug = "hardware_store";
                break;
            case HEALTH:
                slug = "health";
                break;
            case HINDU_TEMPLE:
                slug = "hindu_temple";
                break;
            case HOME_GOODS_STORE:
                slug = "home_goods_store";
                break;
            case HOSPITAL:
                slug = "hospital";
                break;
            case INSURANCE_AGENCY:
                slug = "insurance_agency";
                break;
            case INTERSECTION:
                slug = "intersection";
                break;
            case JEWELRY_STORE:
                slug = "jewelry_store";
                break;
            case LAUNDRY:
                slug = "laundry";
                break;
            case LAWYER:
                slug = "lawyer";
                break;
            case LIBRARY:
                slug = "library";
                break;
            case LIQUOR_STORE:
                slug = "liquor_store";
                break;
            case LOCALITY:
                slug = "locality";
                break;
            case LOCAL_GOVERNMENT_OFFICE:
                slug = "local_government_office";
                break;
            case LOCKSMITH:
                slug = "locksmith";
                break;
            case LODGING:
                slug = "lodging";
                break;
            case MEAL_DELIVERY:
                slug = "meal_delivery";
                break;
            case MEAL_TAKEAWAY:
                slug = "meal_takeaway";
                break;
            case MOSQUE:
                slug = "mosque";
                break;
            case MOVIE_RENTAL:
                slug = "movie_rental";
                break;
            case MOVIE_THEATER:
                slug = "movie_theater";
                break;
            case MOVING_COMPANY:
                slug = "moving_company";
                break;
            case MUSEUM:
                slug = "museum";
                break;
            case NATURAL_FEATURE:
                slug = "natural_feature";
                break;
            case NEIGHBORHOOD:
                slug = "neighborhood";
                break;
            case NIGHT_CLUB:
                slug = "night_club";
                break;
            case OTHER:
                slug = "other";
                break;
            case PAINTER:
                slug = "painter";
                break;
            case PARK:
                slug = "park";
                break;
            case PARKING:
                slug = "parking";
                break;
            case PET_STORE:
                slug = "pet_store";
                break;
            case PHARMACY:
                slug = "pharmacy";
                break;
            case PHYSIOTHERAPIST:
                slug = "physiotherapist";
                break;
            case PLACE_OF_WORSHIP:
                slug = "place_of_worship";
                break;
            case PLUMBER:
                slug = "plumber";
                break;
            case POINT_OF_INTEREST:
                slug = "point_of_interest";
                break;
            case POLICE:
                slug = "police";
                break;
            case POLITICAL:
                slug = "political";
                break;
            case POSTAL_CODE:
                slug = "postal_code";
                break;
            case POSTAL_CODE_PREFIX:
                slug = "postal_code_prefix";
                break;
            case POSTAL_CODE_SUFFIX:
                slug = "postal_code_suffix";
                break;
            case POSTAL_TOWN:
                slug = "postal_town";
                break;
            case POST_BOX:
                slug = "post_box";
                break;
            case POST_OFFICE:
                slug = "post_office";
                break;
            case PREMISE:
                slug = "premise";
                break;
            case REAL_ESTATE_AGENCY:
                slug = "real_estate_agency";
                break;
            case RESTAURANT:
                slug = "restaurant";
                break;
            case ROOFING_CONTRACTOR:
                slug = "roofing_contractor";
                break;
            case ROOM:
                slug = "room";
                break;
            case ROUTE:
                slug = "route";
                break;
            case RV_PARK:
                slug = "rv_park";
                break;
            case SCHOOL:
                slug = "school";
                break;
            case SHOE_STORE:
                slug = "shoe_store";
                break;
            case SHOPPING_MALL:
                slug = "shopping_mall";
                break;
            case SPA:
                slug = "spa";
                break;
            case STADIUM:
                slug = "stadium";
                break;
            case STORAGE:
                slug = "storage";
                break;
            case STORE:
                slug = "store";
                break;
            case STREET_ADDRESS:
                slug = "street_address";
                break;
            case SUBLOCALITY:
                slug = "sublocality";
                break;
            case SUBLOCALITY_LEVEL_1:
                slug = "sublocality_level_1";
                break;
            case SUBLOCALITY_LEVEL_2:
                slug = "sublocality_level_2";
                break;
            case SUBLOCALITY_LEVEL_3:
                slug = "sublocality_level_3";
                break;
            case SUBLOCALITY_LEVEL_4:
                slug = "sublocality_level_4";
                break;
            case SUBLOCALITY_LEVEL_5:
                slug = "sublocality_level_5";
                break;
            case SUBPREMISE:
                slug = "subpremise";
                break;
            case SUBWAY_STATION:
                slug = "subway_station";
                break;
            case SUPERMARKET:
                slug = "supermarket";
                break;
            case SYNAGOGUE:
                slug = "synagogue";
                break;
            case TAXI_STAND:
                slug = "taxi_stand";
                break;
            case TRAIN_STATION:
                slug = "train_station";
                break;
            case TRANSIT_STATION:
                slug = "transit_station";
                break;
            case TRAVEL_AGENCY:
                slug = "travel_agency";
                break;
            case UNIVERSITY:
                slug = "university";
                break;
            case VETERINARY_CARE:
                slug = "veterinary_care";
                break;
            case ZOO:
                slug = "zoo";
                break;                
        
            default:
                slug = "other";
                break;
        }

        return slug;
    }
}