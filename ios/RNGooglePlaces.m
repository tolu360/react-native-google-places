
#import "RNGooglePlaces.h"
#import "NSMutableDictionary+GMSPlace.h"
#import <React/RCTBridge.h>
#import "RNGooglePlacesViewController.h"
#import "RCTConvert+RNGPAutocompleteTypeFilter.h"
#import <React/RCTRootView.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import <GooglePlaces/GooglePlaces.h>

@interface RNGooglePlaces() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property GMSAutocompleteBoundsMode boundsMode;

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
    if (self = [super init]) {
        _instance = self;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        self.boundsMode = kGMSAutocompleteBoundsModeBias;
    }
    
    return self;
}

- (void)dealloc
{
    self.locationManager = nil;
}

RCT_EXPORT_METHOD(openAutocompleteModal: (NSDictionary *)options
                    withFields: (NSArray *)fields
                    resolver: (RCTPromiseResolveBlock)resolve
                    rejecter: (RCTPromiseRejectBlock)reject)
{

    @try {
        RNGooglePlacesViewController* acController = [[RNGooglePlacesViewController alloc] init];

        GMSPlaceField selectedFields = [self getSelectedFields:fields isCurrentOrFetchPlace:false];

        GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
        autocompleteFilter.type = [self getFilterType:[RCTConvert NSString:options[@"type"]]];
        autocompleteFilter.country = [options[@"country"] length] == 0? nil : options[@"country"];
        
        NSDictionary *locationBias = [RCTConvert NSDictionary:options[@"locationBias"]];
        NSDictionary *locationRestriction = [RCTConvert NSDictionary:options[@"locationRestriction"]];
        
        
        GMSCoordinateBounds *autocompleteBounds = [self getBounds:locationBias andRestrictOptions:locationRestriction];

        [acController openAutocompleteModal: autocompleteFilter placeFields: selectedFields bounds: autocompleteBounds boundsMode: self.boundsMode resolver: resolve rejecter: reject];
    }
    @catch (NSException * e) {
        reject(@"E_OPEN_FAILED", @"Could not open modal", [self errorFromException:e]);
    }
}

RCT_EXPORT_METHOD(getAutocompletePredictions: (NSString *)query
                  filterOptions: (NSDictionary *)options
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    NSMutableArray *autoCompleteSuggestionsList = [NSMutableArray array];
    GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
    autocompleteFilter.type = [self getFilterType:[RCTConvert NSString:options[@"type"]]];
    autocompleteFilter.country = [options[@"country"] length] == 0? nil : options[@"country"];
    
    NSDictionary *locationBias = [RCTConvert NSDictionary:options[@"locationBias"]];
    NSDictionary *locationRestriction = [RCTConvert NSDictionary:options[@"locationRestriction"]];
    
    GMSCoordinateBounds *autocompleteBounds = [self getBounds:locationBias andRestrictOptions:locationRestriction];
    
    GMSAutocompleteSessionToken *token = [[GMSAutocompleteSessionToken alloc] init];
    
    [[GMSPlacesClient sharedClient] findAutocompletePredictionsFromQuery:query
                                               bounds:autocompleteBounds
                                               boundsMode:self.boundsMode
                                               filter:autocompleteFilter
                                               sessionToken:token
                                             callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError *error) {
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

    [[GMSPlacesClient sharedClient] fetchPlaceFromPlaceID:placeID placeFields:selectedFields sessionToken:nil
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

- (GMSCoordinateBounds *) getBounds: (NSDictionary *)biasOptions andRestrictOptions: (NSDictionary *)restrictOptions
{
    double biasLatitudeSW = [[RCTConvert NSNumber:biasOptions[@"latitudeSW"]] doubleValue];
    double biasLongitudeSW = [[RCTConvert NSNumber:biasOptions[@"longitudeSW"]] doubleValue];
    double biasLatitudeNE = [[RCTConvert NSNumber:biasOptions[@"latitudeNE"]] doubleValue];
    double biasLongitudeNE = [[RCTConvert NSNumber:biasOptions[@"longitudeNE"]] doubleValue];

    double restrictLatitudeSW = [[RCTConvert NSNumber:restrictOptions[@"latitudeSW"]] doubleValue];
    double restrictLongitudeSW = [[RCTConvert NSNumber:restrictOptions[@"longitudeSW"]] doubleValue];
    double restrictLatitudeNE = [[RCTConvert NSNumber:restrictOptions[@"latitudeNE"]] doubleValue];
    double restrictLongitudeNE = [[RCTConvert NSNumber:restrictOptions[@"longitudeNE"]] doubleValue];

    if (biasLatitudeSW != 0 && biasLongitudeSW != 0 && biasLatitudeNE != 0 && biasLongitudeNE != 0) {
        CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(biasLatitudeNE, biasLongitudeNE);
        CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(biasLatitudeSW, biasLongitudeSW);
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                        coordinate:swBoundsCorner];

        return bounds;
    }  

    if (restrictLatitudeSW != 0 && restrictLongitudeSW != 0 && restrictLatitudeNE != 0 && restrictLongitudeNE != 0) {
        CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(restrictLatitudeNE, restrictLongitudeNE);
        CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(restrictLatitudeSW, restrictLongitudeSW);
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                        coordinate:swBoundsCorner];
        
        self.boundsMode = kGMSAutocompleteBoundsModeRestrict;
        
        return bounds;
    }
    
    return nil;
}


@end

