package com.arttitude360.reactnative.rngoogleplaces;

import android.app.Activity;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.Manifest.permission;
import android.content.pm.PackageManager;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.annotations.ReactProp;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.tasks.Task;
import com.google.android.libraries.places.api.Places;
import com.google.android.libraries.places.api.model.AutocompleteSessionToken;
import com.google.android.libraries.places.api.model.LocationBias;
import com.google.android.libraries.places.api.model.LocationRestriction;
import com.google.android.libraries.places.api.model.Place;
import com.google.android.libraries.places.api.model.RectangularBounds;
import com.google.android.libraries.places.api.model.TypeFilter;
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest;
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsResponse;
import com.google.android.libraries.places.api.net.PlacesClient;
import com.google.android.libraries.places.widget.Autocomplete;
import com.google.android.libraries.places.widget.AutocompleteActivity;
import com.google.android.libraries.places.widget.AutocompleteSupportFragment;
import com.google.android.libraries.places.widget.listener.PlaceSelectionListener;
import com.google.android.libraries.places.widget.model.AutocompleteActivityMode;
import com.google.android.libraries.places.api.model.PlaceLikelihood;
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest;
import com.google.android.libraries.places.api.net.FindCurrentPlaceResponse;
import com.google.android.libraries.places.api.net.PlacesClient;


// import com.google.android.gms.common.ConnectionResult;
// import com.google.android.gms.common.GoogleApiAvailability;
// import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
// import com.google.android.gms.common.GooglePlayServicesRepairableException;
// import com.google.android.gms.common.api.GoogleApiClient;
// import com.google.android.gms.common.api.PendingResult;
// import com.google.android.gms.common.api.ResultCallback;
// import com.google.android.gms.common.api.Status;
// import com.google.android.gms.location.places.AutocompleteFilter;
// import com.google.android.gms.location.places.AutocompletePrediction;
// import com.google.android.gms.location.places.AutocompletePredictionBuffer;
// import com.google.android.gms.location.places.Place;
// import com.google.android.gms.location.places.PlaceBuffer;
// import com.google.android.gms.location.places.PlaceLikelihood;
// import com.google.android.gms.location.places.PlaceLikelihoodBuffer;
// import com.google.android.gms.location.places.Places;
// import com.google.android.gms.location.places.ui.PlaceAutocomplete;
// import com.google.android.gms.location.places.ui.PlacePicker;
// import com.google.android.gms.maps.model.LatLngBounds;
// import com.google.android.gms.maps.model.LatLng;
// import com.google.maps.android.SphericalUtil;

import java.util.Objects;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class RNGooglePlacesModule extends ReactContextBaseJavaModule implements ActivityEventListener {

    private ReactApplicationContext reactContext;
    private Promise pendingPromise;
    public static final String TAG = "RNGooglePlaces";

    // protected GoogleApiClient mGoogleApiClient;

    public static int AUTOCOMPLETE_REQUEST_CODE = 360;
    public static String REACT_CLASS = "RNGooglePlaces";

    public RNGooglePlacesModule(ReactApplicationContext reactContext) {
        super(reactContext);

        // buildGoogleApiClient();

        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(this);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    // protected synchronized void buildGoogleApiClient() {
    //     mGoogleApiClient = new GoogleApiClient.Builder(getReactApplicationContext()).addApi(Places.GEO_DATA_API)
    //             .addApi(Places.PLACE_DETECTION_API).addConnectionCallbacks(this).addOnConnectionFailedListener(this)
    //             .build();

    //     mGoogleApiClient.connect();
    // }

    /**
     * Called after the autocomplete activity has finished to return its result.
     */
    @Override
    public void onActivityResult(Activity activity, final int requestCode, final int resultCode, final Intent intent) {

        // Check that the result was from the autocomplete widget.
        if (requestCode == AUTOCOMPLETE_REQUEST_CODE) {
            if (resultCode == AutocompleteActivity.RESULT_OK) {
                Place place = Autocomplete.getPlaceFromIntent(intent);
                WritableMap map = propertiesMapForPlace(place);

                resolvePromise(map);
            } else if (resultCode == AutocompleteActivity.RESULT_ERROR) {
                Status status = Autocomplete.getStatusFromIntent(intent);
                
                rejectPromise("E_RESULT_ERROR", new Error(status.getStatusMessage()));
            } else if (resultCode == AutocompleteActivity.RESULT_CANCELED) {
                rejectPromise("E_USER_CANCELED", new Error("Search cancelled"));
            }           
        }
    }

    /**
     * Exposed React's methods
     */

    @ReactMethod
    public void openAutocompleteModal(ReadableMap options, ReadableArray fields, final Promise promise) {

        this.pendingPromise = promise;
        String type = options.getString("type");
        String country = options.getString("country");
        country = country.isEmpty() ? null : country;
        String initialQuery = options.getString("initialQuery");
        boolean useOverlay = options.getBoolean("useOverlay");


        ReadableMap locationBias = options.getMap("locationBias");
        double biasToLatitudeSW = locationBias.getDouble("latitudeSW");
        double biasToLongitudeSW = locationBias.getDouble("longitudeSW");
        double biasToLatitudeNE = locationBias.getDouble("latitudeNE");
        double biasToLongitudeNE = locationBias.getDouble("longitudeNE");

        ReadableMap locationRestriction = options.getMap("locationRestriction");
        double restrictToLatitudeSW = locationRestriction.getDouble("latitudeSW");
        double restrictToLongitudeSW = locationRestriction.getDouble("longitudeSW");
        double restrictToLatitudeNE = locationRestriction.getDouble("latitudeNE");
        double restrictToLongitudeNE = locationRestriction.getDouble("longitudeNE");

        Activity currentActivity = getCurrentActivity();
        
        List<Place.Field> selectedFields = getPlaceFields(fields.toArrayList());
        Intent autocompleteIntent = new Autocomplete.IntentBuilder(
                useOverlay ? AutocompleteActivityMode.OVERLAY : AutocompleteActivityMode.FULLSCREEN, selectedFields);

        if (biasToLatitudeSW != 0 && biasToLongitudeSW != 0 && biasToLatitudeNE != 0 && biasToLongitudeNE != 0) {
            autocompleteIntent.setLocationBias(RectangularBounds.newInstance(
                new LatLng(biasToLatitudeSW, biasToLongitudeSW),
                new LatLng(biasToLatitudeNE, biasToLongitudeNE)));
        }

        if (restrictToLatitudeSW != 0 && restrictToLongitudeSW != 0 && restrictToLatitudeNE != 0 && restrictToLongitudeNE != 0) {
            autocompleteIntent.setLocationRestriction(RectangularBounds.newInstance(
                new LatLng(restrictToLatitudeSW, restrictToLongitudeSW),
                new LatLng(restrictToLatitudeNE, restrictToLongitudeNE)));
        }

        if (country != null) {
            autocompleteIntent.setCountry(country);
        }

        autocompleteIntent.setTypeFilter(getFilterType(type));

        currentActivity.startActivityForResult(autocompleteIntent.build(currentActivity), AUTOCOMPLETE_REQUEST_CODE);        
    }

    @ReactMethod
    public void getAutocompletePredictions(String query, ReadableMap options, final Promise promise) {
        this.pendingPromise = promise;

        String type = options.getString("type");
        String country = options.getString("country");
        country = country.isEmpty() ? null : country;
        boolean useSessionToken = options.getBoolean("useSessionToken");

        ReadableMap locationBias = options.getMap("locationBias");
        double biasToLatitudeSW = locationBias.getDouble("latitudeSW");
        double biasToLongitudeSW = locationBias.getDouble("longitudeSW");
        double biasToLatitudeNE = locationBias.getDouble("latitudeNE");
        double biasToLongitudeNE = locationBias.getDouble("longitudeNE");

        ReadableMap locationRestriction = options.getMap("locationRestriction");
        double restrictToLatitudeSW = locationRestriction.getDouble("latitudeSW");
        double restrictToLongitudeSW = locationRestriction.getDouble("longitudeSW");
        double restrictToLatitudeNE = locationRestriction.getDouble("latitudeNE");
        double restrictToLongitudeNE = locationRestriction.getDouble("longitudeNE");
        
        FindAutocompletePredictionsRequest.Builder requestBuilder =
        FindAutocompletePredictionsRequest.builder()
        .setQuery(query);
        
        if (country != null) {
            requestBuilder.setCountry(country);
        }
        
        if (biasToLatitudeSW != 0 && biasToLongitudeSW != 0 && biasToLatitudeNE != 0 && biasToLongitudeNE != 0) {
            requestBuilder.setLocationBias(RectangularBounds.newInstance(
                new LatLng(biasToLatitudeSW, biasToLongitudeSW),
                new LatLng(biasToLatitudeNE, biasToLongitudeNE)));
        }

        if (restrictToLatitudeSW != 0 && restrictToLongitudeSW != 0 && restrictToLatitudeNE != 0 && restrictToLongitudeNE != 0) {
            requestBuilder.setLocationRestriction(RectangularBounds.newInstance(
                new LatLng(restrictToLatitudeSW, restrictToLongitudeSW),
                new LatLng(restrictToLatitudeNE, restrictToLongitudeNE)));
        }
            
        requestBuilder.setTypeFilter(getFilterType(type));

        if (useSessionToken) {
            requestBuilder.setSessionToken(AutocompleteSessionToken.newInstance());
        }
            
        Task<FindAutocompletePredictionsResponse> task =
            placesClient.findAutocompletePredictions(requestBuilder.build());
    
        task.addOnSuccessListener(
            (response) -> {
                if (response.getAutocompletePredictions().size() == 0) {
                    WritableArray emptyResult = Arguments.createArray();
                    promise.resolve(emptyResult);
                    return;
                }
    
                WritableArray predictionsList = Arguments.createArray();
    
                for (AutocompletePrediction prediction : response.getAutocompletePredictions()) {
                    WritableMap map = Arguments.createMap();
                    map.putString("fullText", prediction.getFullText(null).toString());
                    map.putString("primaryText", prediction.getPrimaryText(null).toString());
                    map.putString("secondaryText", prediction.getSecondaryText(null).toString());
                    map.putString("placeID", prediction.getPlaceId().toString());
    
                    if (prediction.getPlaceTypes() != null) {
                        List<String> types = new ArrayList<>();
                        for (Integer placeType : prediction.getPlaceTypes()) {
                            types.add(findPlaceTypeLabelByPlaceTypeId(placeType));
                        }
                        map.putArray("types", Arguments.fromArray(types.toArray(new String[0])));
                    }
    
                    predictionsList.pushMap(map);
                }
    
                promise.resolve(predictionsList);
    
            });
    
        task.addOnFailureListener(
            (exception) -> {
                promise.reject("E_AUTOCOMPLETE_ERROR", new Error(exception.getMessage()));
                return;
            });       
    }

    @ReactMethod
    public void lookUpPlaceByID(String placeID, ReadableArray fields, final Promise promise) {
        this.pendingPromise = promise;
        
        List<Place.Field> selectedFields = getPlaceFields(fields.toArrayList());

        FetchPlaceRequest request = FetchPlaceRequest.builder(placeID, selectedFields).build();

        placesClient.fetchPlace(request).addOnSuccessListener((response) -> {
            Place place = response.getPlace();
            WritableMap map = propertiesMapForPlace(place);

            promise.resolve(map);
        }).addOnFailureListener((exception) -> {
            promise.reject("E_PLACE_DETAILS_ERROR", new Error(exception.getMessage()));
            return;
        });
    }

    @ReactMethod
    public void getCurrentPlace(ReadableArray fields, final Promise promise) {
        if (ContextCompat.checkSelfPermission(this.reactContext.getApplicationContext(), permission.ACCESS_WIFI_STATE)
            != PackageManager.PERMISSION_GRANTED
        || ContextCompat.checkSelfPermission(this.reactContext.getApplicationContext(), permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {        
            promise.reject("E_CURRENT_PLACE_ERROR", new Error("Both ACCESS_WIFI_STATE & ACCESS_FINE_LOCATION permissions are required"));
            return;
        }

        List<Place.Field> selectedFields = getPlaceFields(fields.toArrayList());

        if (checkPermission(ACCESS_FINE_LOCATION)) {
            findCurrentPlaceWithPermissions(selectedFields, promise);
        }
    }

    /**
   * Fetches a list of {@link PlaceLikelihood} instances that represent the Places the user is
   * most
   * likely to be at currently.
   */
    @RequiresPermission(allOf = {ACCESS_FINE_LOCATION, ACCESS_WIFI_STATE})
    private void findCurrentPlaceWithPermissions(List<Place.Field> selectedFields, final Promise promise) {

        FindCurrentPlaceRequest currentPlaceRequest =
            FindCurrentPlaceRequest.newInstance(selectedFields);
        Task<FindCurrentPlaceResponse> currentPlaceTask =
            placesClient.findCurrentPlace(currentPlaceRequest);

        currentPlaceTask.addOnSuccessListener(
            (response) -> {
                if (response.getPlaceLikelihoods().size() == 0) {
                    WritableArray emptyResult = Arguments.createArray();
                    promise.resolve(emptyResult);
                    return;
                }

                WritableArray likelyPlacesList = Arguments.createArray();

                for (PlaceLikelihood placeLikelihood : response.getPlaceLikelihoods()) {

                    WritableMap map = propertiesMapForPlace(placeLikelihood.getPlace());
                    map.putDouble("likelihood", placeLikelihood.getLikelihood());

                    likelyPlacesList.pushMap(map);
                }

                promise.resolve(likelyPlacesList);
            });

        currentPlaceTask.addOnFailureListener(
            (exception) -> {
                promise.reject("E_CURRENT_PLACE_ERROR", new Error(exception.getMessage()));
                return;
            });
    }

    private WritableMap propertiesMapForPlace(Place place) {
        // Display attributions if required.
        CharSequence attributions = place.getAttributions();

        WritableMap map = Arguments.createMap();
        map.putDouble("latitude", place.getLatLng().latitude);
        map.putDouble("longitude", place.getLatLng().longitude);
        map.putString("name", place.getName().toString());

        if (!TextUtils.isEmpty(place.getAddress())) {
            map.putString("address", place.getAddress().toString());
        }

        if (!TextUtils.isEmpty(place.getPhoneNumber())) {
            map.putString("phoneNumber", place.getPhoneNumber().toString());
        }

        if (null != place.getWebsiteUri()) {
            map.putString("website", place.getWebsiteUri().toString());
        }

        map.putString("placeID", place.getId());

        if (!TextUtils.isEmpty(attributions)) {
            map.putString("attributions", attributions.toString());
        }

        if (place.getPlaceTypes() != null) {
            List<String> types = new ArrayList<>();
            for (Integer placeType : place.getPlaceTypes()) {
                types.add(findPlaceTypeLabelByPlaceTypeId(placeType));
            }
            map.putArray("types", Arguments.fromArray(types.toArray(new String[0])));
        }

        if (place.getViewport() != null) {
            map.putDouble("north", place.getViewport().northeast.latitude);
            map.putDouble("east", place.getViewport().northeast.longitude);
            map.putDouble("south", place.getViewport().southwest.latitude);
            map.putDouble("west", place.getViewport().southwest.longitude);
        }

        if (place.getPriceLevel() >= 0) {
            map.putInt("priceLevel", place.getPriceLevel());
        }

        if (place.getRating() >= 0) {
            map.putDouble("rating", place.getRating());
        }

        return map;
    }

    @Nullable
    private TypeFilter getFilterType(String type) {
        TypeFilter mappedFilter;

        switch (type) {
        case "geocode":
            mappedFilter = TypeFilter.TYPE_FILTER_GEOCODE;
            break;
        case "address":
            mappedFilter = TypeFilter.TYPE_FILTER_ADDRESS;
            break;
        case "establishment":
            mappedFilter = TypeFilter.TYPE_FILTER_ESTABLISHMENT;
            break;
        case "regions":
            mappedFilter = TypeFilter.TYPE_FILTER_REGIONS;
            break;
        case "cities":
            mappedFilter = TypeFilter.TYPE_FILTER_CITIES;
            break;
        default:
            mappedFilter = null;
            break;
        }

        return mappedFilter;
    }

    private List<Place.Field> getPlaceFields(ArrayList<String> placeFields) {
        List<Place.Field> selectedFields = new ArrayList<>();

        if (placeFields.size() == 0) {
            return Place.Field.values();
        }

        for (String placeField : placeFields) {
            selectedFields.add(RNGooglePlacesPlaceFieldEnum.findByFieldKey(placeField).getField());            
        }

        return selectedFields;
    }

    private boolean checkPermission(String permission) {
        boolean hasPermission =
            ContextCompat.checkSelfPermission(this.reactContext.getApplicationContext(), permission) == PackageManager.PERMISSION_GRANTED;
        if (!hasPermission) {
          ActivityCompat.requestPermissions(getCurrentActivity(), new String[]{permission}, 0);
        }
        return hasPermission;
    }

    private void rejectPromise(String code, Error err) {
        if (this.pendingPromise != null) {
            this.pendingPromise.reject(code, err);
            this.pendingPromise = null;
        }
    }

    private void resolvePromise(Object data) {
        if (this.pendingPromise != null) {
            this.pendingPromise.resolve(data);
            this.pendingPromise = null;
        }
    }

    private LatLngBounds getLatLngBounds(LatLng center, double radius) {
        LatLng southwest = SphericalUtil.computeOffset(center, radius * Math.sqrt(2.0), 225);
        LatLng northeast = SphericalUtil.computeOffset(center, radius * Math.sqrt(2.0), 45);
        return new LatLngBounds(southwest, northeast);
    }

    private String findPlaceTypeLabelByPlaceTypeId(Integer id) {
        return RNGooglePlacesPlaceTypeEnum.findByTypeId(id).getLabel();
    }

    // check before any use of Google API Client
    private boolean isClientDisconnected() {
        if (!mGoogleApiClient.isConnecting() &&
                !mGoogleApiClient.isConnected()) {
            rejectPromise("E_GOOGLE_CLIENT_DISCONNECTED", new Error("GoogleApiClient is not connected. Will try connect again"));
            // this will trigger again resolution on connection failure when
            // autoClientResolution is true and if has resolution
            mGoogleApiClient.connect();
            return true;
        }

        return false;
    }

    @Override
    public void onNewIntent(Intent intent) {
    }

    @Override
    public void onConnected(Bundle connectionHint) {
        Log.i(TAG, "GoogleApiClient Connected");
    }

    @Override
    public void onConnectionFailed(ConnectionResult result) {
        // Refer to Google Play documentation for what errors can be logged
        boolean hasResolution = result.hasResolution();

        Log.i(TAG, "GoogleApiClient: connection failed with error: " + result.getErrorMessage() +
                " (" + result.getErrorCode() + ")" +
                ", has resolution: " +
                (hasResolution ? "YES" : "NO"));

        if (hasResolution) {
            Activity activity = getCurrentActivity();
            if (activity != null) {
                try {
                    result.startResolutionForResult(activity, PLACES_RESOLUTION_CODE);
                } catch (IntentSender.SendIntentException e) {
                    e.printStackTrace();
                }
            } else {
                // activity sometimes not attached to react context on app start,
                // client connection will be checked before making request
                Log.i(TAG, "GoogleApiClient: can't resolve, activity == null");
            }
        }
    }

    @Override
    public void onConnectionSuspended(int cause) {
        // Attempts to reconnect if a disconnect occurs
        Log.i(TAG, "GoogleApiClient Connection Suspended");
    }
}
