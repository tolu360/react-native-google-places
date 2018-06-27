package com.arttitude360.reactnative.rngoogleplaces;

import android.app.Activity;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

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
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.places.AutocompleteFilter;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Place;
import com.google.android.gms.location.places.PlaceBuffer;
import com.google.android.gms.location.places.PlaceLikelihood;
import com.google.android.gms.location.places.PlaceLikelihoodBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.location.places.ui.PlaceAutocomplete;
import com.google.android.gms.location.places.ui.PlacePicker;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.LatLng;
import com.google.maps.android.SphericalUtil;

import java.util.Objects;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class RNGooglePlacesModule extends ReactContextBaseJavaModule implements ActivityEventListener,
        GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {

    private ReactApplicationContext reactContext;
    private Promise pendingPromise;
    public static final String TAG = "RNGooglePlaces";

    protected GoogleApiClient mGoogleApiClient;

    public static int AUTOCOMPLETE_REQUEST_CODE = 360;
    public static int PLACE_PICKER_REQUEST_CODE = 361;
    public static int PLACES_RESOLUTION_CODE = 362;
    public static String REACT_CLASS = "RNGooglePlaces";

    public RNGooglePlacesModule(ReactApplicationContext reactContext) {
        super(reactContext);

        buildGoogleApiClient();

        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(this);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    protected synchronized void buildGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(getReactApplicationContext()).addApi(Places.GEO_DATA_API)
                .addApi(Places.PLACE_DETECTION_API).addConnectionCallbacks(this).addOnConnectionFailedListener(this)
                .build();

        mGoogleApiClient.connect();
    }

    /**
     * Called after the autocomplete activity has finished to return its result.
     */
    @Override
    public void onActivityResult(Activity activity, final int requestCode, final int resultCode, final Intent data) {

        // Check that the result was from the autocomplete widget.
        if (requestCode == AUTOCOMPLETE_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                // Get the user's selected place from the Intent.
                Place place = PlaceAutocomplete.getPlace(this.reactContext.getApplicationContext(), data);
                Log.i(TAG, "Place Selected: " + place.getName());

                WritableMap map = propertiesMapForPlace(place);

                resolvePromise(map);

            } else if (resultCode == PlaceAutocomplete.RESULT_ERROR) {
                Status status = PlaceAutocomplete.getStatus(this.reactContext.getApplicationContext(), data);
                Log.e(TAG, "Error: Status = " + status.toString());
                rejectPromise("E_RESULT_ERROR", new Error(status.toString()));
            } else if (resultCode == Activity.RESULT_CANCELED) {
                // Indicates that the activity closed before a selection was made. For example if
                // the user pressed the back button.
                rejectPromise("E_USER_CANCELED", new Error("Search cancelled"));
            }
        }

        if (requestCode == PLACE_PICKER_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                Place place = PlacePicker.getPlace(this.reactContext.getApplicationContext(), data);

                Log.i(TAG, "Place Selected: " + place.getName());

                WritableMap map = propertiesMapForPlace(place);

                resolvePromise(map);
            }
        }

        if (requestCode == PLACES_RESOLUTION_CODE) {
            Log.i(TAG, "Google API Client resolution result: " + resultCode);
            if (resultCode == Activity.RESULT_OK) {
                if (!mGoogleApiClient.isConnecting() &&
                        !mGoogleApiClient.isConnected()) {
                    mGoogleApiClient.connect();
                }
            }
        }
    }

    /**
     * Exposed React's methods
     */

    @ReactMethod
    public void openAutocompleteModal(ReadableMap options, final Promise promise) {

        this.pendingPromise = promise;
        String type = options.getString("type");
        String country = options.getString("country");
        country = country.isEmpty() ? null : country;
        boolean useOverlay = options.getBoolean("useOverlay");

        double latitude = options.getDouble("latitude");
        double longitude = options.getDouble("longitude");
        double radius = options.getDouble("radius");
        LatLng center = new LatLng(latitude, longitude);

        Activity currentActivity = getCurrentActivity();

        try {
            // The autocomplete activity requires Google Play Services to be available. The intent
            // builder checks this and throws an exception if it is not the case.
            PlaceAutocomplete.IntentBuilder intentBuilder = new PlaceAutocomplete.IntentBuilder(
                    useOverlay ? PlaceAutocomplete.MODE_OVERLAY : PlaceAutocomplete.MODE_FULLSCREEN);

            if (latitude != 0 && longitude != 0 && radius != 0) {
                intentBuilder.setBoundsBias(this.getLatLngBounds(center, radius));
            }
            Intent intent = intentBuilder.setFilter(getFilterType(type, country)).build(currentActivity);

            currentActivity.startActivityForResult(intent, AUTOCOMPLETE_REQUEST_CODE);
        } catch (GooglePlayServicesRepairableException e) {
            // Indicates that Google Play Services is either not installed or not up to date. Prompt
            // the user to correct the issue.
            GoogleApiAvailability.getInstance()
                    .getErrorDialog(currentActivity, e.getConnectionStatusCode(), AUTOCOMPLETE_REQUEST_CODE).show();
        } catch (GooglePlayServicesNotAvailableException e) {
            // Indicates that Google Play Services is not available and the problem is not easily
            // resolvable.
            String message = "Google Play Services is not available: "
                    + GoogleApiAvailability.getInstance().getErrorString(e.errorCode);

            Log.e(TAG, message);

            rejectPromise("E_INTENT_ERROR", new Error("Google Play Services is not available"));
        }
    }

    @ReactMethod
    public void openPlacePickerModal(ReadableMap options, final Promise promise) {
        this.pendingPromise = promise;
        Activity currentActivity = getCurrentActivity();
        double latitude = options.getDouble("latitude");
        double longitude = options.getDouble("longitude");
        double radius = options.getDouble("radius");
        LatLng center = new LatLng(latitude, longitude);

        try {
            PlacePicker.IntentBuilder intentBuilder = new PlacePicker.IntentBuilder();

            if (latitude != 0 && longitude != 0 && radius != 0) {
                intentBuilder.setLatLngBounds(this.getLatLngBounds(center, radius));
            }
            Intent intent = intentBuilder.build(currentActivity);

            // Start the Intent by requesting a result, identified by a request code.
            currentActivity.startActivityForResult(intent, PLACE_PICKER_REQUEST_CODE);

        } catch (GooglePlayServicesRepairableException e) {
            GoogleApiAvailability.getInstance()
                    .getErrorDialog(currentActivity, e.getConnectionStatusCode(), PLACE_PICKER_REQUEST_CODE).show();
        } catch (GooglePlayServicesNotAvailableException e) {

            rejectPromise("E_INTENT_ERROR", new Error("Google Play Services is not available"));
        }
    }

    @ReactMethod
    public void getAutocompletePredictions(String query, ReadableMap options, final Promise promise) {
        this.pendingPromise = promise;

        if (this.isClientDisconnected()) return;

        String type = options.getString("type");
        String country = options.getString("country");
        country = country.isEmpty() ? null : country;

        double latitude = options.getDouble("latitude");
        double longitude = options.getDouble("longitude");
        double radius = options.getDouble("radius");
        LatLng center = new LatLng(latitude, longitude);

        LatLngBounds bounds = null;

        if (latitude != 0 && longitude != 0 && radius != 0) {
            bounds = this.getLatLngBounds(center, radius);
        }

        PendingResult<AutocompletePredictionBuffer> results = Places.GeoDataApi
                .getAutocompletePredictions(mGoogleApiClient, query, bounds, getFilterType(type, country));

        AutocompletePredictionBuffer autocompletePredictions = results.await(60, TimeUnit.SECONDS);

        final Status status = autocompletePredictions.getStatus();

        if (status.isSuccess()) {
            if (autocompletePredictions.getCount() == 0) {
                WritableArray emptyResult = Arguments.createArray();
                autocompletePredictions.release();
                promise.resolve(emptyResult);
                return;
            }

            WritableArray predictionsList = Arguments.createArray();

            for (AutocompletePrediction prediction : autocompletePredictions) {
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

            // Release the buffer now that all data has been copied.
            autocompletePredictions.release();
            promise.resolve(predictionsList);

        } else {
            Log.i(TAG, "Error making autocomplete prediction API call: " + status.toString());
            autocompletePredictions.release();
            promise.reject("E_AUTOCOMPLETE_ERROR",
                    new Error("Error making autocomplete prediction API call: " + status.toString()));
            return;
        }
    }

    @ReactMethod
    public void lookUpPlaceByID(String placeID, final Promise promise) {
        this.pendingPromise = promise;

        if (this.isClientDisconnected()) return;

        Places.GeoDataApi.getPlaceById(mGoogleApiClient, placeID).setResultCallback(new ResultCallback<PlaceBuffer>() {
            @Override
            public void onResult(PlaceBuffer places) {
                if (places.getStatus().isSuccess()) {
                    if (places.getCount() == 0) {
                        WritableMap emptyResult = Arguments.createMap();
                        places.release();
                        promise.resolve(emptyResult);
                        return;
                    }

                    final Place place = places.get(0);

                    WritableMap map = propertiesMapForPlace(place);

                    // Release the PlaceBuffer to prevent a memory leak
                    places.release();

                    promise.resolve(map);

                } else {
                    places.release();
                    promise.reject("E_PLACE_DETAILS_ERROR",
                            new Error("Error making place lookup API call: " + places.getStatus().toString()));
                    return;
                }
            }
        });
    }

    @ReactMethod
    public void lookUpPlacesByIDs(ReadableArray placeIDs, final Promise promise) {
        List<Object> placeIDsObjects = placeIDs.toArrayList();
        List<String> placeIDsStrings = new ArrayList<>(placeIDsObjects.size());
        for (Object item : placeIDsObjects) {
            placeIDsStrings.add(Objects.toString(item, null));
        }

        Places.GeoDataApi.getPlaceById(mGoogleApiClient, placeIDsStrings.toArray(new String[placeIDsStrings.size()]))
                .setResultCallback(new ResultCallback<PlaceBuffer>() {
                    @Override
                    public void onResult(PlaceBuffer places) {
                        if (places.getStatus().isSuccess()) {
                            if (places.getCount() == 0) {
                                WritableMap emptyResult = Arguments.createMap();
                                places.release();
                                promise.resolve(emptyResult);
                                return;
                            }

                            WritableArray resultList = processLookupByIDsPlaces(places);

                            // Release the PlaceBuffer to prevent a memory leak
                            places.release();

                            promise.resolve(resultList);
                        } else {
                            places.release();
                            promise.reject("E_PLACE_DETAILS_ERROR",
                                    new Error("Error making place lookup API call: " + places.getStatus().toString()));
                            return;
                        }
                    }
                });
    }

    @ReactMethod
    public void getCurrentPlace(final Promise promise) {
        Places.PlaceDetectionApi.getCurrentPlace(mGoogleApiClient, null)
            .setResultCallback(new ResultCallback<PlaceLikelihoodBuffer>() {
                @Override
                public void onResult(PlaceLikelihoodBuffer likelyPlaces) {
                    final Status status = likelyPlaces.getStatus();

                    if (status.isSuccess()) {
                        if (likelyPlaces.getCount() == 0) {
                            WritableArray emptyResult = Arguments.createArray();
                            likelyPlaces.release();
                            promise.resolve(emptyResult);
                            return;
                        }

                        WritableArray likelyPlacesList = Arguments.createArray();

                        for (PlaceLikelihood placeLikelihood : likelyPlaces) {
                            WritableMap map = propertiesMapForPlace(placeLikelihood.getPlace());
                            map.putDouble("likelihood", placeLikelihood.getLikelihood());

                            likelyPlacesList.pushMap(map);
                        }

                        // Release the buffer now that all data has been copied.
                        likelyPlaces.release();
                        promise.resolve(likelyPlacesList);
                    } else {
                        Log.i(TAG, "Error making places detection api call: " + status.getStatusMessage());
                        likelyPlaces.release();
                        promise.reject("E_PLACE_DETECTION_API_ERROR",
                                new Error("Error making places detection api call: " + status.getStatusMessage()));
                        return;
                    }
                }
            });
    }

    private WritableArray processLookupByIDsPlaces(final PlaceBuffer places) {
        WritableArray resultList = new WritableNativeArray();

        for (Place place : places) {
            resultList.pushMap(propertiesMapForPlace(place));
        }

        return resultList;
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

    private AutocompleteFilter getFilterType(String type, String country) {
        AutocompleteFilter mappedFilter;

        switch (type) {
        case "geocode":
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_GEOCODE)
                    .setCountry(country).build();
            break;
        case "address":
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_ADDRESS)
                    .setCountry(country).build();
            break;
        case "establishment":
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_ESTABLISHMENT)
                    .setCountry(country).build();
            break;
        case "regions":
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_REGIONS)
                    .setCountry(country).build();
            break;
        case "cities":
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_CITIES)
                    .setCountry(country).build();
            break;
        default:
            mappedFilter = new AutocompleteFilter.Builder().setTypeFilter(AutocompleteFilter.TYPE_FILTER_NONE)
                    .setCountry(country).build();
            break;
        }

        return mappedFilter;
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
