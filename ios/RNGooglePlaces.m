
#import "RNGooglePlaces.h"
#import "NSMutableDictionary+GMSPlace.h"
#import <React/RCTBridge.h>
#import "RNGooglePlacesViewController.h"
#import "RCTConvert+RNGPAutocompleteTypeFilter.h"
#import <React/RCTRootView.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@interface RNGooglePlaces() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property GMSAutocompleteSessionToken *sessionToken;

@end


@implementation RNGooglePlaces

RNGooglePlaces *_instance;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (instancetype)init
{
    NSString *placesApiKey = @"AIzaSyBzVFvs0eutiD8YIzZuJqc7KUg25wpwWbg";
    [GMSPlacesClient provideAPIKey:placesApiKey];
    [GMSServices provideAPIKey:placesApiKey];
    if (self = [super init]) {
        _instance = self;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    self.locationManager = nil;
}

RCT_EXPORT_METHOD(beginAutocompleteSession: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject) {
    self.sessionToken = [GMSAutocompleteSessionToken new];
    resolve(nil);
}

RCT_EXPORT_METHOD(finishAutocompleteSession: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject) {
    self.sessionToken = nil;
    resolve(nil);
}

RCT_EXPORT_METHOD(getAutocompletePredictions: (NSString *)query
                  filterOptions: (NSDictionary *)options
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    NSMutableArray *autoCompleteSuggestionsList = [NSMutableArray array];
    GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
    NSString *filterTypeString = [RCTConvert NSString:options[@"type"]];
    NSArray *filterTypes = filterTypeString ? @[filterTypeString] : nil;
    autocompleteFilter.types = filterTypes;
  
    NSString *filterCountryString = [RCTConvert NSString:options[@"country"]];
    NSArray *filterCountries = filterCountryString ? @[filterCountryString] : nil;
    autocompleteFilter.countries = filterCountries;
    
    NSDictionary *locationBiasDict = [RCTConvert NSDictionary:options[@"locationBias"]];
    if (locationBiasDict) {
        CLLocationDegrees northEastLat = [locationBiasDict[@"latitudeNE"] doubleValue];
        CLLocationDegrees northEastLng = [locationBiasDict[@"longitudeNE"] doubleValue];
        CLLocationDegrees southWestLat = [locationBiasDict[@"longitudeSW"] doubleValue];
        CLLocationDegrees southWestLng = [locationBiasDict[@"latitudeSW"] doubleValue];

        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(northEastLat, northEastLng);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(southWestLat, southWestLng);
        autocompleteFilter.locationBias = GMSPlaceRectangularLocationOption(northEast, southWest);
    }
  
    NSDictionary *locationRestriction = [RCTConvert NSDictionary:options[@"locationRestriction"]];
    if (locationRestriction) {
      CLLocationDegrees northEastLat = [locationRestriction[@"latitudeNE"] doubleValue];
      CLLocationDegrees northEastLng = [locationRestriction[@"longitudeNE"] doubleValue];
      CLLocationDegrees southWestLat = [locationRestriction[@"longitudeSW"] doubleValue];
      CLLocationDegrees southWestLng = [locationRestriction[@"latitudeSW"] doubleValue];

      CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(northEastLat, northEastLng);
      CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(southWestLat, southWestLng);
      autocompleteFilter.locationRestriction = GMSPlaceRectangularLocationOption(northEast, southWest);
    }
  
  [[GMSPlacesClient sharedClient] findAutocompletePredictionsFromQuery:query filter:autocompleteFilter sessionToken:self.sessionToken callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError *error) {
    if (error != nil) {
      reject(@"E_AUTOCOMPLETE_ERROR", [error description], nil);
      return;
    }
    
    if (results != nil) {
      for (GMSAutocompletePrediction* result in results) {
        NSMutableDictionary *placeData = [[NSMutableDictionary alloc] init];
        
        placeData[@"fullText"] = result.attributedFullText.string;
        placeData[@"primaryText"] = result.attributedPrimaryText.string;
        placeData[@"secondaryText"] = result.attributedSecondaryText.string;
        placeData[@"placeID"] = result.placeID;
        placeData[@"types"] = result.types;
        
        [autoCompleteSuggestionsList addObject:placeData];
      }
      
      resolve(autoCompleteSuggestionsList);
      
    }
    
  }];
}

RCT_EXPORT_METHOD(lookUpPlaceByID: (NSString*)placeID
                  withFields: (NSArray *)fields
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    GMSPlaceField selectedFields = [self getSelectedFields:fields isCurrentOrFetchPlace:false];
    
    [[GMSPlacesClient sharedClient] fetchPlaceFromPlaceID:placeID placeFields:selectedFields sessionToken:self.sessionToken
                                                 callback:^(GMSPlace * _Nullable place, NSError * _Nullable error) {
        if (error != nil) {
            reject(@"E_PLACE_DETAILS_ERROR", [error localizedDescription], nil);
            return;
        }
        
        if (place != nil) {
            resolve([NSMutableDictionary dictionaryWithGMSPlace:place]);
        } else {
            resolve(@{});
        }
    }];
}

RCT_EXPORT_METHOD(getCurrentPlace: (NSArray *)fields
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    [self.locationManager requestAlwaysAuthorization];
    
    
    GMSPlaceField selectedFields = [self getSelectedFields:fields isCurrentOrFetchPlace:true];
    
    NSMutableArray *likelyPlacesList = [NSMutableArray array];
    
    [[GMSPlacesClient sharedClient] findPlaceLikelihoodsFromCurrentLocationWithPlaceFields:selectedFields callback:^(NSArray<GMSPlaceLikelihood *> * _Nullable likelihoods, NSError * _Nullable error) {
        if (error != nil) {
            reject(@"E_CURRENT_PLACE_ERROR", [error localizedDescription], nil);
            return;
        }
        
        if (likelihoods != nil) {
            for (GMSPlaceLikelihood *likelihood in likelihoods) {
                NSMutableDictionary *placeData = [NSMutableDictionary dictionaryWithGMSPlace:likelihood.place];
                placeData[@"likelihood"] = [NSNumber numberWithDouble:likelihood.likelihood];
                
                [likelyPlacesList addObject:placeData];
            }
        }
        
        resolve(likelyPlacesList);
    }];
}

- (NSError *) errorFromException: (NSException *) exception
{
    NSDictionary *exceptionInfo = @{
        @"name": exception.name,
        @"reason": exception.reason,
        @"callStackReturnAddresses": exception.callStackReturnAddresses,
        @"callStackSymbols": exception.callStackSymbols,
        @"userInfo": exception.userInfo
    };
    
    return [[NSError alloc] initWithDomain: @"RNGooglePlaces"
                                      code: 0
                                  userInfo: exceptionInfo];
}

- (GMSPlacesAutocompleteTypeFilter) getFilterType:(NSString *)type
{
    if ([type isEqualToString: @"regions"]) {
        return kGMSPlacesAutocompleteTypeFilterRegion;
    } else if ([type isEqualToString: @"geocode"]) {
        return kGMSPlacesAutocompleteTypeFilterGeocode;
    } else if ([type isEqualToString: @"address"]) {
        return kGMSPlacesAutocompleteTypeFilterAddress;
    } else if ([type isEqualToString: @"establishment"]) {
        return kGMSPlacesAutocompleteTypeFilterEstablishment;
    } else if ([type isEqualToString: @"cities"]) {
        return kGMSPlacesAutocompleteTypeFilterCity;
    } else {
        return kGMSPlacesAutocompleteTypeFilterNoFilter;
    }
}

- (GMSPlaceField) getSelectedFields:(NSArray *)fields isCurrentOrFetchPlace:(Boolean)currentOrFetch
{
    NSDictionary *fieldsMapping = @{
        @"name" : @(GMSPlaceFieldName),
        @"placeID" : @(GMSPlaceFieldPlaceID),
        @"plusCode" : @(GMSPlaceFieldPlusCode),
        @"location" : @(GMSPlaceFieldCoordinate),
        @"openingHours" : @(GMSPlaceFieldOpeningHours),
        @"phoneNumber" : @(GMSPlaceFieldPhoneNumber),
        @"address" : @(GMSPlaceFieldFormattedAddress),
        @"rating" : @(GMSPlaceFieldRating),
        @"userRatingsTotal" : @(GMSPlaceFieldUserRatingsTotal),
        @"priceLevel" : @(GMSPlaceFieldPriceLevel),
        @"types" : @(GMSPlaceFieldTypes),
        @"website" : @(GMSPlaceFieldWebsite),
        @"viewport" : @(GMSPlaceFieldViewport),
        @"addressComponents" : @(GMSPlaceFieldAddressComponents),
        @"photos" : @(GMSPlaceFieldPhotos),
    };
    
    if ([fields count] == 0 && !currentOrFetch) {
        return GMSPlaceFieldAll;
    }
    
    if ([fields count] == 0 && currentOrFetch) {
        GMSPlaceField placeFields = 0;
        for (NSString *fieldLabel in fieldsMapping) {
            if ([fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldOpeningHours &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldPhoneNumber &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldWebsite &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldAddressComponents) {
                placeFields |= [fieldsMapping[fieldLabel] integerValue];
            }
        }
        return placeFields;
    }
    
    if ([fields count] != 0 && currentOrFetch) {
        GMSPlaceField placeFields = 0;
        for (NSString *fieldLabel in fields) {
            if ([fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldOpeningHours &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldPhoneNumber &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldWebsite &&
                [fieldsMapping[fieldLabel] integerValue] != GMSPlaceFieldAddressComponents) {
                placeFields |= [fieldsMapping[fieldLabel] integerValue];
            }
        }
        return placeFields;
    }
    
    if ([fields count] != 0 && !currentOrFetch) {
        GMSPlaceField placeFields = 0;
        for (NSString *fieldLabel in fields) {
            placeFields |= [fieldsMapping[fieldLabel] integerValue];
        }
        return placeFields;
    }
    
    return GMSPlaceFieldAll;
}
@end
