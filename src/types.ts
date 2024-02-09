export interface LatLng {
  longitude: number;
  latitude: number;
}

export interface GeoCoordinateBounds {
  latitudeSW: number;
  longitudeSW: number;
  latitudeNE: number;
  longitudeNE: number;
}

/**
 * Internal mappings to Google Maps Services types.
 */
export namespace GMSTypes {
  /**
   * Internal mapping to [GMSPlace](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place)
   * and [com.google.android.libraries.places.api.model.Place](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/Place).
   *
   * Represents a particular physical space.
   *
   * A Place encapsulates information about a physical location, including
   * its name, address, and any other information we might have about it.
   */
  export interface Place {
    /**
     * Name of the place.
     */
    name: string;

    /**
     * Place ID of this place.
     *
     * For more information: [Place IDs](https://developers.google.com/places/place-id)
     */
    placeID: string;

    /**
     * The Plus code representation of location for this place.
     */
    plusCode: PlusCode;

    /**
     * Location of the place.
     *
     * Corresponds to [coordinates](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place.html#a3dc43865df0de69b6b1203a15a745efc)
     * and [getLatLng](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/Place.html#getLatLng()).
     */
    location: LatLng;

    /**
     * The Opening Hours information for this place.
     *
     * The mapping only contains the weekday text, i.e.
     * [GMSOpeningHours#weekdayTest](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_opening_hours.html#a6a4cd04495230795fcd04d814c71d107)
     * and [OpeningHours#getWeekdayTest](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/OpeningHours.html#getWeekdayText()).
     */
    openingHours: string[];

    /**
     * Phone number of this place, in international format, i.e. including the
     * country code prefixed with "+". For example, Google Sydney's phone
     * number is "+61 2 9374 4000".
     */
    phoneNumber: string;

    /**
     * Simple address of the Place.
     *
     * Corresponds to [formattedAddress](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place.html#a8926a762ae78bcd18c0ea126d270ef3d)
     * and [getAddress](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/Place.html#getAddress())
     */
    address: string;

    /**
     * Five-star rating for this place based on user reviews.
     *
     * Ratings range from 1.0 to 5.0. 0.0 means we have no rating for this
     * place (e.g. because not enough users have reviewed this place).
     */
    rating: number;

    /**
     * Represents how many reviews make up this place's rating.
     */
    userRatingsTotal: number;

    /**
     * Price level for this place, as integers from 0 to 4.
     *
     * e.g. A value of 4 means this place is "$$$$" (expensive). A value of 0
     * means free (such as a museum with free admission).
     */
    priceLevel: any;

    /**
     * The types of this place.
     */
    types: ReturnPlaceType[];

    /**
     * Website for this place.
     *
     * This is the URI of the website maintained by the Place, if available.
     * This link is always for a third-party website not affiliated with the
     * Places API.
     *
     * Corresponds to [website](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place.html#a7b9ee24d284ac279eed7f83a838354fe)
     * and [getWebsiteUri](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/Place.html#getWebsiteUri()).
     */
    website: string;

    /**
     * This returns a viewport of a size that is suitable for displaying this
     * place. For example, a Place object representing a store may have a
     * relatively small viewport, while a Place object representing a country
     * may have a very large viewport.
     */
    viewport: GeoCoordinateBounds;

    /**
     * Address components. If you need the full address, consider using
     * `address` instead.
     */
    addressComponents: Array<AddressComponent>;
  }

  /**
   * Internal mapping to [GMSPlusCode](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place)
   * and [com.google.android.libraries.places.api.model.PlusCode](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/PlusCode).
   *
   * A class containing the Plus codes representation for a location.
   *
   * Plus Code, or Open Location Code (OLC), is a geocode system for
   * identifying any geographical area on Earth, even when a street address
   * does not exist.
   *
   * See https://plus.codes/ for more details.
   */
  export interface PlusCode {
    /**
     * Geo plus code, e.g.
     * "8FVC9G8F+5W"
     */
    globalCode: string;

    /**
     * Compound plus code, e.g.
     * "9G8F+5W Zurich, Switzerland"
     */
    compoundCode: string;
  }

  /**
   * Place Type, corresponding to the
   * [return types table 1](https://developers.google.com/places/ios-sdk/supported_types).
   *
   * You can use the following values in the `types` filter for place
   * [searches](https://developers.google.com/places/web-service/search)
   * (Places API only). These types may also be returned anywhere a Place
   * result is returned (for example as part of the
   * [Place Details](https://developers.google.com/places/android-sdk/place-details)
   * resulting from a call to `fetchPlace()`).
   */
  export type PlaceType =
    | 'accounting'
    | 'airport'
    | 'amusement_park'
    | 'aquarium'
    | 'art_gallery'
    | 'atm'
    | 'bakery'
    | 'bank'
    | 'bar'
    | 'beauty_salon'
    | 'bicycle_store'
    | 'book_store'
    | 'bowling_alley'
    | 'bus_station'
    | 'cafe'
    | 'campground'
    | 'car_dealer'
    | 'car_rental'
    | 'car_repair'
    | 'car_wash'
    | 'casino'
    | 'cemetery'
    | 'church'
    | 'city_hall'
    | 'clothing_store'
    | 'convenience_store'
    | 'courthouse'
    | 'dentist'
    | 'department_store'
    | 'doctor'
    | 'electrician'
    | 'electronics_store'
    | 'embassy'
    | 'fire_station'
    | 'florist'
    | 'funeral_home'
    | 'furniture_store'
    | 'gas_station'
    | 'gym'
    | 'hair_care'
    | 'hardware_store'
    | 'hindu_temple'
    | 'home_goods_store'
    | 'hospital'
    | 'insurance_agency'
    | 'jewelry_store'
    | 'laundry'
    | 'lawyer'
    | 'library'
    | 'liquor_store'
    | 'local_government_office'
    | 'locksmith'
    | 'lodging'
    | 'meal_delivery'
    | 'meal_takeaway'
    | 'mosque'
    | 'movie_rental'
    | 'movie_theater'
    | 'moving_company'
    | 'museum'
    | 'night_club'
    | 'painter'
    | 'park'
    | 'parking'
    | 'pet_store'
    | 'pharmacy'
    | 'physiotherapist'
    | 'plumber'
    | 'police'
    | 'post_office'
    | 'real_estate_agency'
    | 'restaurant'
    | 'roofing_contractor'
    | 'rv_park'
    | 'school'
    | 'shoe_store'
    | 'shopping_mall'
    | 'spa'
    | 'stadium'
    | 'storage'
    | 'store'
    | 'subway_station'
    | 'supermarket'
    | 'synagogue'
    | 'taxi_stand'
    | 'train_station'
    | 'transit_station'
    | 'travel_agency'
    | 'veterinary_care'
    | 'zoo';

  /**
   * Place Type, corresponding to the
   * [return types table 2](https://developers.google.com/places/ios-sdk/supported_types).
   *
   * The following types may be returned anywhere a Place result is returned
   * (for example a [Find Place](https://developers.google.com/places/web-service/search#FindPlaceRequests)
   * request), in addition to the types in table 1 above. These types are also
   * used for address components.
   *
   * For more details on these types, refer to
   * [Address Types](https://developers.google.com/maps/documentation/geocoding/intro#Types).
   *
   * Note: The types below are not supported in the type filter of a place
   * search.
   */
  export type ReadOnlyPlaceType =
    | 'administrative_area_level_1'
    | 'administrative_area_level_2'
    | 'administrative_area_level_3'
    | 'administrative_area_level_4'
    | 'administrative_area_level_5'
    | 'colloquial_area'
    | 'country'
    | 'establishment'
    | 'finance'
    | 'floor'
    | 'food'
    | 'general_contractor'
    | 'geocode'
    | 'health'
    | 'intersection'
    | 'locality'
    | 'natural_feature'
    | 'neighborhood'
    | 'place_of_worship'
    | 'political'
    | 'point_of_interest'
    | 'post_box'
    | 'postal_code'
    | 'postal_code_prefix'
    | 'postal_code_suffix'
    | 'postal_town'
    | 'premise'
    | 'room'
    | 'route'
    | 'street_address'
    | 'street_number'
    | 'sublocality'
    | 'sublocality_level_4'
    | 'sublocality_level_5'
    | 'sublocality_level_3'
    | 'sublocality_level_2'
    | 'sublocality_level_1'
    | 'subpremise';

  /**
   * All the different kinds of place types that the Places API can return.
   */
  export type ReturnPlaceType = ReadOnlyPlaceType | PlaceType;

  /**
   * Place Type, corresponding to the
   * [return types table 3](https://developers.google.com/places/ios-sdk/supported_types).
   *
   * You may restrict results from a Place Autocomplete request to be of a
   * certain type by passing a `types` parameter. The parameter specifies a
   * type or a type collection, as listed in the supported types below. If
   * nothing is specified, all types are returned. In general only a single
   * type is allowed. The exception is that you can safely mix the `geocode`
   * and `establishment` types, but note that this will have the same effect
   * as specifying no types.
   *
   * ## `geocode`
   *
   * Instructs the Place Autocomplete service to return only geocoding
   * results, rather than business results. Generally, you use this request
   * to disambiguate results where the location specified may be
   * indeterminate.
   *
   * ## `address`
   *
   * Instructs the Place Autocomplete service to return only geocoding
   * results with a precise address. Generally, you use this request when
   * you know the user will be looking for a fully specified address.
   *
   * ## `establishment`
   *
   * Instructs the Place Autocomplete service to return only business
   * results.
   *
   * ## `regions`
   *
   * Instructs the Places service to return any result matching the
   * following types:
   *
   * - `locality` (PlaceType.Locality)
   * - `sublocality` (PlaceType.SubLocality)
   * - `postal_code` (PlaceType.PostalCode)
   * - `country` (PlaceType.Country)
   * - `administrative_area_level_1` (PlaceType.AdministrativeAreaLevel1)
   * - `administrative_area_level_2` (PlaceType.AdministrativeAreaLevel2)
   *
   * ## `cities`
   *
   * Instructs the Places service to return results that match `locality`
   * (PlaceType.Locality) or `administrative_area_level_3`
   * (PlaceType.AdministrativeAreaLevel3).
   */
  export type AutocompleteType =
    | 'geocode'
    | 'address'
    | 'establishment'
    | 'regions'
    | 'cities';

  /**
   * Internal mapping to [AddressComponent](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_address_component)
   * and [com.google.android.libraries.places.api.model.AddressComponent](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/AddressComponent).
   *
   * Represents a component of an address, e.g., street number, postcode,
   * city, etc.
   */
  export interface AddressComponent {
    /**
     * Type of the address component.
     */
    types: ReturnPlaceType[];

    /**
     * Name of the address component, e.g. "Sydney".
     */
    name: string;

    /**
     * Short name of the address component, e.g. "AU".
     */
    shortName: string;
  }

  /**
   * Internal mapping to [GMSAutocompletePrediction](https://developers.google.com/places/ios-sdk/reference/https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_autocomplete_prediction)
   * and [com.google.android.libraries.places.api.model.AutocompletePrediction](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/AutocompletePrediction).
   *
   * Represents an autocomplete suggestion of a place, based on a particular
   * text query.
   *
   * An AutocompletePrediction includes the description of the suggested place
   * as well as basic details including place ID and types.
   */
  export interface AutocompletePrediction {
    /**
     * The full text of a place. This is a combination of the primary text
     * and the secondary text.
     *
     * Example: "Eiffel Tower, Avenue Anatole France, Paris, France"
     */
    fullText: string;

    /**
     * Returns the primary text of a place. This will usually be the name of
     * the place.
     *
     * Example: "Eiffel Tower", "123 Pitt Street"
     */
    primaryText: string;

    /**
     * Returns the secondary text of a place. This provides extra context on
     * the place, and can be used as a second line when showing autocomplete
     * predictions.
     *
     * Example: "Avenue Anatole France, Paris, France", "Sydney, New South
     * Wales"
     */
    secondaryText: string;

    /**
     * Returns the place ID of the place being referred to by this prediction.
     *
     * For more information: [Place IDs](https://developers.google.com/places/place-id)
     */
    placeID: string;

    /**
     * The types of this autocomplete result.
     */
    types?: ReturnPlaceType;
  }
}
