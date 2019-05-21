declare module "react-native-google-places" {
  /**
   * 2D Coordinate bounds for view boxes etc, as defined by the bottom left and
   * top right corners.
   * 
   * There isn't a direct correspondence between this type and native types.
   */
  export interface GeoCoordinateBounds {
    latitudeSW: number;
    longitudeSW: number;
    latitudeNE: number;
    longitudeNE: number;
  }

  /**
   * Standard cross-platform coordinate type.
   * 
   * Corresponds to [CLLocationCoordinate2D](https://developer.apple.com/documentation/corelocation/cllocationcoordinate2d)
   * and [LatLng](https://developers.google.com/android/reference/com/google/android/gms/maps/model/LatLng).
   */
  export interface LatLng {
    longitude: number;
    latitude: number;
  }

  /**
   * Current place, with additional likelihood property.
   * 
   * Corresponds roughly to
   * [GMSPlaceLikelihood](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_place_likelihood.html#a370caf145921ced6374bd39212561d90)
   * and [com.google.android.libraries.places.api.net.PlaceLikelihood](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/PlaceLikelihood),
   * though the likelihood has been flattened into the Place object.
   */
  export interface CurrentPlace extends GMSTypes.Place {
    /**
     * Returns a value from 0.0 to 1.0 indicating the confidence that the user
     * is at this place.
     * 
     * The larger the value the more confident we are of the place returned. For
     * example, a likelihood of 0.75 means that the user is at least 75% likely
     * to be at this place.
     */
    likelihood: number;
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
      types: PlaceType[];

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
      addressComponents: AddressComponent;
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
    export enum PlaceType {
      Accounting = "accounting",
      Airport = "airport",
      AmusementPark = "amusement_park",
      Aquarium = "aquarium",
      ArtGallery = "art_gallery",
      Atm = "atm",
      Bakery = "bakery",
      Bank = "bank",
      Bar = "bar",
      BeautySalon = "beauty_salon",
      BicycleStore = "bicycle_store",
      BookStore = "book_store",
      BowlingAlley = "bowling_alley",
      BusStation = "bus_station",
      Cafe = "cafe",
      Campground = "campground",
      CarDealer = "car_dealer",
      CarRental = "car_rental",
      CarRepair = "car_repair",
      CarWash = "car_wash",
      Casino = "casino",
      Cemetery = "cemetery",
      Church = "church",
      CityHall = "city_hall",
      ClothingStore = "clothing_store",
      ConvenienceStore = "convenience_store",
      Courthouse = "courthouse",
      Dentist = "dentist",
      DepartmentStore = "department_store",
      Doctor = "doctor",
      Electrician = "electrician",
      ElectronicsStore = "electronics_store",
      Embassy = "embassy",
      FireStation = "fire_station",
      Florist = "florist",
      FuneralHome = "funeral_home",
      FurnitureStore = "furniture_store",
      GasStation = "gas_station",
      Gym = "gym",
      HairCare = "hair_care",
      HardwareStore = "hardware_store",
      HinduTemple = "hindu_temple",
      HomeGoodsStore = "home_goods_store",
      Hospital = "hospital",
      InsuranceAgency = "insurance_agency",
      JewelryStore = "jewelry_store",
      Laundry = "laundry",
      Lawyer = "lawyer",
      Library = "library",
      LiquorStore = "liquor_store",
      LocalGovernmentOffice = "local_government_office",
      Locksmith = "locksmith",
      Lodging = "lodging",
      MealDelivery = "meal_delivery",
      MealTakeaway = "meal_takeaway",
      Mosque = "mosque",
      MovieRental = "movie_rental",
      MovieTheater = "movie_theater",
      MovingCompany = "moving_company",
      Museum = "museum",
      NightClub = "night_club",
      Painter = "painter",
      Park = "park",
      Parking = "parking",
      PetStore = "pet_store",
      Pharmacy = "pharmacy",
      Physiotherapist = "physiotherapist",
      Plumber = "plumber",
      Police = "police",
      PostOffice = "post_office",
      RealEstateAgency = "real_estate_agency",
      Restaurant = "restaurant",
      RoofingContractor = "roofing_contractor",
      RvPark = "rv_park",
      School = "school",
      ShoeStore = "shoe_store",
      ShoppingMall = "shopping_mall",
      Spa = "spa",
      Stadium = "stadium",
      Storage = "storage",
      Store = "store",
      SubwayStation = "subway_station",
      Supermarket = "supermarket",
      Synagogue = "synagogue",
      TaxiStand = "taxi_stand",
      TrainStation = "train_station",
      TransitStation = "transit_station",
      TravelAgency = "travel_agency",
      VeterinaryCare = "veterinary_care",
      Zoo = "zoo",
    }

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
    export enum ReadOnlyPlaceType {
      AdministrativeAreaLevel1 = "administrative_area_level_1",
      AdministrativeAreaLevel2 = "administrative_area_level_2",
      AdministrativeAreaLevel3 = "administrative_area_level_3",
      AdministrativeAreaLevel4 = "administrative_area_level_4",
      AdministrativeAreaLevel5 = "administrative_area_level_5",
      ColloquialArea = "colloquial_area",
      Country = "country",
      Establishment = "establishment",
      Finance = "finance",
      Floor = "floor",
      Food = "food",
      GeneralContractor = "general_contractor",
      Geocode = "geocode",
      Health = "health",
      Intersection = "intersection",
      Locality = "locality",
      NaturalFeature = "natural_feature",
      Neighborhood = "neighborhood",
      PlaceOfWorship = "place_of_worship",
      Political = "political",
      PointOfInterest = "point_of_interest",
      PostBox = "post_box",
      PostalCode = "postal_code",
      PostalCodePrefix = "postal_code_prefix",
      PostalCodeSuffix = "postal_code_suffix",
      PostalTown = "postal_town",
      Premise = "premise",
      Room = "room",
      Route = "route",
      StreetAddress = "street_address",
      StreetNumber = "street_number",
      Sublocality = "sublocality",
      SublocalityLevel4 = "sublocality_level_4",
      SublocalityLevel5 = "sublocality_level_5",
      SublocalityLevel3 = "sublocality_level_3",
      SublocalityLevel2 = "sublocality_level_2",
      SublocalityLevel1 = "sublocality_level_1",
      Subpremise = "subpremise", 
    }

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
     */
    export enum AutocompleteType {
      /**
       * Instructs the Place Autocomplete service to return only geocoding
       * results, rather than business results. Generally, you use this request
       * to disambiguate results where the location specified may be
       * indeterminate.
       */
      Geocode = "geocode",

      /**
       * Instructs the Place Autocomplete service to return only geocoding
       * results with a precise address. Generally, you use this request when
       * you know the user will be looking for a fully specified address.
       */
      Address = "address",

      /**
       * Instructs the Place Autocomplete service to return only business
       * results.
       */
      Establishment = "establishment",

      /**
       * Instructs the Places service to return any result matching the
       * following types:
       * 
       * - `locality` (PlaceType.Locality)
       * - `sublocality` (PlaceType.SubLocality)
       * - `postal_code` (PlaceType.PostalCode)
       * - `country` (PlaceType.Country)
       * - `administrative_area_level_1` (PlaceType.AdministrativeAreaLevel1)
       * - `administrative_area_level_2` (PlaceType.AdministrativeAreaLevel2)
       */
      Regions = "regions",

      /**
       * Instructs the Places service to return results that match `locality`
       * (PlaceType.Locality) or `administrative_area_level_3`
       * (PlaceType.AdministrativeAreaLevel3).
       */
      Cities = "cities",
    }

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

  /**
   * Google Places options.
   * 
   * This type roughly corresponds to
   * [GMSAutocompleteFilter](https://developers.google.com/places/ios-sdk/reference/interface_g_m_s_autocomplete_filter)
   * and [com.google.android.libraries.places.widget.Autocomplete](https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/widget/Autocomplete).
   */
  export interface RNGooglePlacesNativeOptions {
    /**
     * The type of results to return.
     */
    type: GMSTypes.AutocompleteType;

    /**
     * Limit results to a specific country using a
     * [ISO 3166-1 Alpha-2 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
     * (case insensitive). If this is not set, no country filtering will take
     * place.
     */
    country: string;

    /**
     * If true, the autocomplete modal will
     * [open as an overlay rather than fullscreen](https://developers.google.com/places/images/acw_overlay.png).
     * 
     * Note: This property is Android only.
     */
    useOverlay: boolean;

    /**
     * If present, the autocomplete modal would launch with results
     * pre-populated for the query passed.
     * 
     * Note: This property is Android only.
     */
    initialQuery: string;
    useSessionToken: boolean;

    /**
     * To bias autocomplete results to a specific geographic region.
     * 
     * Note: On iOS, only one of locationBias or locationRestriction is
     * respected, when passing both, only the first passed option would be used.
     */
    locationBias: GeoCoordinateBounds;

    /**
     * To restrict autocomplete results to a specific geographic region.
     * 
     * Note: On iOS, only one of locationBias or locationRestriction is
     * respected, when passing both, only the first passed option would be used.
     */
    locationRestriction: GeoCoordinateBounds;
  }

  class RNGooglePlacesNative {
    public openAutocompleteModal<K extends keyof GMSTypes.Place>(
      autocompleteFilter: RNGooglePlacesNativeOptions, placeFields: K[],
    ): Promise<Promise<Pick<GMSTypes.Place, (typeof placeFields)[number]>>>;

    public getAutocompletePredictions(
      query: string, filterOptions: RNGooglePlacesNativeOptions,
    ): Promise<GMSTypes.AutocompletePrediction[]>;

    public lookUpPlaceByID<K extends keyof GMSTypes.Place>(
      placeID: string, placeFields: K[]
    ): Promise<Pick<GMSTypes.Place, (typeof placeFields)[number]>>;

    public getCurrentPlace<K extends keyof GMSTypes.Place>(
      placeFields: K[]
    ): Promise<
      Pick<CurrentPlace, (typeof placeFields)[number] | "likelihood">[]
    >;
  }

  class RNGooglePlaces {
    static optionsDefaults: {
      type: '',
      country: '',
      useOverlay: false,
      initialQuery: '',
      useSessionToken: true,
      locationBias: {
        latitudeSW: 0,
        longitudeSW: 0,
        latitudeNE: 0,
        longitudeNE: 0,
      },
      locationRestriction: {
        latitudeSW: 0,
        longitudeSW: 0,
        latitudeNE: 0,
        longitudeNE: 0,
      }
    };

    static placeFieldsDefaults: (keyof GMSTypes.Place)[];

    /**
     * Note: To prevent yourself from incurring huge usage bill, you should
     * select the result fields you need in your application.
     */
    public openAutocompleteModal(
      options?: Partial<RNGooglePlacesNativeOptions>,
    ): Promise<GMSTypes.Place>;

    public openAutocompleteModal<K extends keyof GMSTypes.Place>(
      options: Partial<RNGooglePlacesNativeOptions>, placeFields: K[],
    ): Promise<Pick<GMSTypes.Place, (typeof placeFields)[number]>>;

    /**
     * If you have specific branding needs or you would rather build out your
     * own custom search input and suggestions list (think Uber), you should
     * call these methods to call the native SDKs directly.
     */
    public getAutocompletePredictions(
      query: string, options?: Partial<RNGooglePlacesNativeOptions>,
    ): Promise<GMSTypes.AutocompletePrediction[]>;

    /**
     * For more information: [Place IDs](https://developers.google.com/places/place-id)
     */
    public lookUpPlaceByID(placeID: string): Promise<GMSTypes.Place>;

    /**
     * For more information: [Place IDs](https://developers.google.com/places/place-id) 
     */
    public lookUpPlaceByID<K extends keyof GMSTypes.Place>(
      placeID: string, placeFields: K[]
    ): Promise<Pick<GMSTypes.Place, (typeof placeFields)[number]>>;

    /**
     * This method returns to you the place where the device is currently
     * located (that is, the place at the device's currently-reported location).
     * 
     * For each place, the result includes an indication of the likelihood that
     * the place is the right one. A higher value for likelihood means a greater
     * probability that the place is the best match. Ensure you have required
     * the appropriate permissions as stated post-install steps above before
     * making this request.
     * 
     * The sum of the likelihoods in a given result set is always less than or
     * equal to 1.0. 
     * 
     * Note: To prevent yourself from incurring huge usage bill, you should
     * select only the result fields you need in your application.
     */
    public getCurrentPlace(): Promise<CurrentPlace[]>;

    /**
     * This method returns to you the place where the device is currently
     * located (that is, the place at the device's currently-reported location).
     * 
     * For each place, the result includes an indication of the likelihood that
     * the place is the right one. A higher value for likelihood means a greater
     * probability that the place is the best match. Ensure you have required
     * the appropriate permissions as stated post-install steps above before
     * making this request.
     * 
     * The sum of the likelihoods in a given result set is always less than or
     * equal to 1.0. 
     */
    public getCurrentPlace<K extends keyof GMSTypes.Place>(
      placeFields: K[]
    ): Promise<
      Pick<CurrentPlace, (typeof placeFields)[number] | "likelihood">[]
    >;
  }

  const _: RNGooglePlaces;
  export default _;
}
