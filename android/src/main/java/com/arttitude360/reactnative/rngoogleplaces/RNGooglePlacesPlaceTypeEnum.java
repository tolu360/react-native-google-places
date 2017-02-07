package com.arttitude360.reactnative.rngoogleplaces;

import android.util.SparseArray;

/**
 * Mapping between {@link com.google.android.gms.location.places.Place}'s class id and label, to fit with iOS functionality
 */
public enum RNGooglePlacesPlaceTypeEnum {
    TYPE_OTHER(0, "other"),
    TYPE_ACCOUNTING(1, "accounting"),
    TYPE_AIRPORT(2, "airport"),
    TYPE_AMUSEMENT_PARK(3, "amusement_park"),
    TYPE_AQUARIUM(4, "aquarium"),
    TYPE_ART_GALLERY(5, "art_gallery"),
    TYPE_ATM(6, "atm"),
    TYPE_BAKERY(7, "bakery"),
    TYPE_BANK(8, "bank"),
    TYPE_BAR(9, "bar"),
    TYPE_BEAUTY_SALON(10, "beauty_salon"),
    TYPE_BICYCLE_STORE(11, "bicycle_store"),
    TYPE_BOOK_STORE(12, "book_store"),
    TYPE_BOWLING_ALLEY(13, "bowling_alley"),
    TYPE_BUS_STATION(14, "bus_station"),
    TYPE_CAFE(15, "cafe"),
    TYPE_CAMPGROUND(16, "campground"),
    TYPE_CAR_DEALER(17, "car_dealer"),
    TYPE_CAR_RENTAL(18, "car_rental"),
    TYPE_CAR_REPAIR(19, "car_repair"),
    TYPE_CAR_WASH(20, "car_wash"),
    TYPE_CASINO(21, "casino"),
    TYPE_CEMETERY(22, "cemetery"),
    TYPE_CHURCH(23, "church"),
    TYPE_CITY_HALL(24, "city_hall"),
    TYPE_CLOTHING_STORE(25, "clothing_store"),
    TYPE_CONVENIENCE_STORE(26, "convenience_store"),
    TYPE_COURTHOUSE(27, "courthouse"),
    TYPE_DENTIST(28, "dentist"),
    TYPE_DEPARTMENT_STORE(29, "department_store"),
    TYPE_DOCTOR(30, "doctor"),
    TYPE_ELECTRICIAN(31, "electrician"),
    TYPE_ELECTRONICS_STORE(32, "electronics_store"),
    TYPE_EMBASSY(33, "embassy"),
    TYPE_ESTABLISHMENT(34, "establishment"),
    TYPE_FINANCE(35, "finance"),
    TYPE_FIRE_STATION(36, "fire_station"),
    TYPE_FLORIST(37, "florist"),
    TYPE_FOOD(38, "food"),
    TYPE_FUNERAL_HOME(39, "funeral_home"),
    TYPE_FURNITURE_STORE(40, "furniture_store"),
    TYPE_GAS_STATION(41, "gas_station"),
    TYPE_GENERAL_CONTRACTOR(42, "general_contractor"),
    TYPE_GROCERY_OR_SUPERMARKET(43, "grocery_or_supermarket"),
    TYPE_GYM(44, "gym"),
    TYPE_HAIR_CARE(45, "hair_care"),
    TYPE_HARDWARE_STORE(46, "hardware_store"),
    TYPE_HEALTH(47, "health"),
    TYPE_HINDU_TEMPLE(48, "hindu_temple"),
    TYPE_HOME_GOODS_STORE(49, "home_goods_store"),
    TYPE_HOSPITAL(50, "hospital"),
    TYPE_INSURANCE_AGENCY(51, "insurance_agency"),
    TYPE_JEWELRY_STORE(52, "jewelry_store"),
    TYPE_LAUNDRY(53, "laundry"),
    TYPE_LAWYER(54, "lawyer"),
    TYPE_LIBRARY(55, "library"),
    TYPE_LIQUOR_STORE(56, "liquor_store"),
    TYPE_LOCAL_GOVERNMENT_OFFICE(57, "local_government_office"),
    TYPE_LOCKSMITH(58, "locksmith"),
    TYPE_LODGING(59, "lodging"),
    TYPE_MEAL_DELIVERY(60, "meal_delivery"),
    TYPE_MEAL_TAKEAWAY(61, "meal_takeaway"),
    TYPE_MOSQUE(62, "mosque"),
    TYPE_MOVIE_RENTAL(63, "movie_rental"),
    TYPE_MOVIE_THEATER(64, "movie_theater"),
    TYPE_MOVING_COMPANY(65, "moving_company"),
    TYPE_MUSEUM(66, "museum"),
    TYPE_NIGHT_CLUB(67, "night_club"),
    TYPE_PAINTER(68, "painter"),
    TYPE_PARK(69, "park"),
    TYPE_PARKING(70, "parking"),
    TYPE_PET_STORE(71, "pet_store"),
    TYPE_PHARMACY(72, "pharmacy"),
    TYPE_PHYSIOTHERAPIST(73, "physiotherapist"),
    TYPE_PLACE_OF_WORSHIP(74, "place_of_worship"),
    TYPE_PLUMBER(75, "plumber"),
    TYPE_POLICE(76, "police"),
    TYPE_POST_OFFICE(77, "post_office"),
    TYPE_REAL_ESTATE_AGENCY(78, "real_estate_agency"),
    TYPE_RESTAURANT(79, "restaurant"),
    TYPE_ROOFING_CONTRACTOR(80, "roofing_contractor"),
    TYPE_RV_PARK(81, "rv_park"),
    TYPE_SCHOOL(82, "school"),
    TYPE_SHOE_STORE(83, "shoe_store"),
    TYPE_SHOPPING_MALL(84, "shopping_mall"),
    TYPE_SPA(85, "spa"),
    TYPE_STADIUM(86, "stadium"),
    TYPE_STORAGE(87, "storage"),
    TYPE_STORE(88, "store"),
    TYPE_SUBWAY_STATION(89, "subway_station"),
    TYPE_SYNAGOGUE(90, "synagogue"),
    TYPE_TAXI_STAND(91, "taxi_stand"),
    TYPE_TRAIN_STATION(92, "train_station"),
    TYPE_TRAVEL_AGENCY(93, "travel_agency"),
    TYPE_UNIVERSITY(94, "university"),
    TYPE_VETERINARY_CARE(95, "veterinary_care"),
    TYPE_ZOO(96, "zoo"),
    TYPE_ADMINISTRATIVE_AREA_LEVEL_1(1001, "administrative_area_level_1"),
    TYPE_ADMINISTRATIVE_AREA_LEVEL_2(1002, "administrative_area_level_2"),
    TYPE_ADMINISTRATIVE_AREA_LEVEL_3(1003, "administrative_area_level_3"),
    TYPE_COLLOQUIAL_AREA(1004, "colloquial_area"),
    TYPE_COUNTRY(1005, "country"),
    TYPE_FLOOR(1006, "floor"),
    TYPE_GEOCODE(1007, "geocode"),
    TYPE_INTERSECTION(1008, "intersection"),
    TYPE_LOCALITY(1009, "locality"),
    TYPE_NATURAL_FEATURE(1010, "natural_feature"),
    TYPE_NEIGHBORHOOD(1011, "neighborhood"),
    TYPE_POLITICAL(1012, "political"),
    TYPE_POINT_OF_INTEREST(1013, "point_of_interest"),
    TYPE_POST_BOX(1014, "post_box"),
    TYPE_POSTAL_CODE(1015, "postal_code"),
    TYPE_POSTAL_CODE_PREFIX(1016, "postal_code_prefix"),
    TYPE_POSTAL_TOWN(1017, "postal_town"),
    TYPE_PREMISE(1018, "premise"),
    TYPE_ROOM(1019, "room"),
    TYPE_ROUTE(1020, "route"),
    TYPE_STREET_ADDRESS(1021, "street_address"),
    TYPE_SUBLOCALITY(1022, "sublocality"),
    TYPE_SUBLOCALITY_LEVEL_1(1023, "sublocality_level_1"),
    TYPE_SUBLOCALITY_LEVEL_2(1024, "sublocality_level_2"),
    TYPE_SUBLOCALITY_LEVEL_3(1025, "sublocality_level_3"),
    TYPE_SUBLOCALITY_LEVEL_4(1026, "sublocality_level_4"),
    TYPE_SUBLOCALITY_LEVEL_5(1027, "sublocality_level_5"),
    TYPE_SUBPREMISE(1028, "subpremise"),
    TYPE_SYNTHETIC_GEOCODE(1029, "synthetic_geocode"),
    TYPE_TRANSIT_STATION(1030, "transit_station");

    private final String label;

    private static class Indexer {
        private static SparseArray<RNGooglePlacesPlaceTypeEnum> index = new SparseArray<>();
    }

    RNGooglePlacesPlaceTypeEnum(int id, String label) {
        this.label = label;
        Indexer.index.put(id, this);
    }

    public String getLabel() {
        return label;
    }

    public static RNGooglePlacesPlaceTypeEnum findByTypeId(Integer id) {
        RNGooglePlacesPlaceTypeEnum typeEnum = Indexer.index.get(id);
        if (typeEnum != null) return typeEnum;
        return TYPE_OTHER;
    }
}
