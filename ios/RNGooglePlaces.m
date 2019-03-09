
#import "RNGooglePlaces.h"
#import "NSMutableDictionary+GMSPlace.h"
#import <React/RCTBridge.h>
#import "RNGooglePlacesViewController.h"
#import "RCTConvert+RNGPAutocompleteTypeFilter.h"
#import "RNGooglePlacesGMSPlaceFields.h"
#import <React/RCTRootView.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import <GooglePlaces/GooglePlaces.h>

@implementation RNGooglePlaces

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(openAutocompleteModal: (NSDictionary *)options
                    withFields: (NSArray *)fields
                    resolver: (RCTPromiseResolveBlock)resolve
                    rejecter: (RCTPromiseRejectBlock)reject)
{

    @try {
        RNGooglePlacesViewController* acController = [[RNGooglePlacesViewController alloc] init];

        GMSPlaceField selectedFields = [self getSelectedFields:fields isCurrentOrFetchPlace:false];
        acController.placeFields = selectedFields;

        GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
        autocompleteFilter.type = [self getFilterType:[RCTConvert NSString:options[@"type"]]];
        autocompleteFilter.country = [options[@"country"] length] == 0? nil : options[@"country"];
        
        NSDictionary *boundsMap = [self getBounds:options[@"locationBias"] andRestrictOptions:options[@"locationRestriction"]];
        (GMSCoordinateBounds*) autocompleteBounds = boundsMap[@"bounds"];
        (GMSAutocompleteBoundsMode) autocompleteBoundsMode = boundsMap[@"boundsMode"];

        [acController openAutocompleteModal: autocompleteFilter bounds: autocompleteBounds boundsMode: autocompleteBoundsMode resolver: resolve rejecter: reject];
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

    NSDictionary *boundsMap = [self getBounds:options[@"locationBias"] andRestrictOptions:options[@"locationRestriction"]];
    (GMSCoordinateBounds*) autocompleteBounds = boundsMap[@"bounds"];
    (GMSAutocompleteBoundsMode) autocompleteBoundsMode = boundsMap[@"boundsMode"];
    
    [[GMSPlacesClient sharedClient] findAutocompletePredictionsFromQuery:query
                                               bounds:autocompleteBounds
                                               boundsMode:autocompleteBoundsMode
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
    GMSPlaceField selectedFields = [self getSelectedFields:fields isCurrentOrFetchPlace:true];

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
        return nil;
    }
}

- (GMSPlaceField) getSelectedFields:(NSArray *)fields isCurrentOrFetchPlace:(boolean)currentOrFetch
{
    if ([fields count] == 0 && !currentOrFetch) {
        return GMSPlaceFieldAll;
    }

    if ([fields count] == 0 && currentOrFetch) {
        GMSPlaceField placeFields = 0;
        for (NSString *fieldLabel in fieldsMapping) {
            if (fieldsMapping[fieldLabel] != GMSPlaceFieldName) {
                placeFields |= [fieldsMapping[fieldLabel] integerValue];
            }
        }
        return placeFields;
    }

    if ([fields count] != 0 && currentOrFetch) {
        GMSPlaceField placeFields = 0;
        for (NSString *fieldLabel in fields) {
            if (fieldsMapping[fieldLabel] != GMSPlaceFieldName) {
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
}

- (NSDictionary) getBounds: (NSDictionary *)biasOptions andRestrictOptions: (NSDictionary *)restrictOptions
{
    GMSAutocompleteBoundsMode boundsMode = kGMSAutocompleteBoundsModeBias;
    GMSCoordinateBounds *bounds;

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

        NSDictionary *boundsMap = @{
            @"bounds" : @(bounds),
            @"boundsMode" : @(boundsMode),
        };

        return boundsMap;
    }  

    if (restrictLatitudeSW != 0 && restrictLongitudeSW != 0 && restrictLatitudeNE != 0 && restrictLongitudeNE != 0) {
        CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(restrictLatitudeNE, restrictLongitudeNE);
        CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(restrictLatitudeSW, restrictLongitudeSW);
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                        coordinate:swBoundsCorner];
        
        boundsMode = kGMSAutocompleteBoundsModeRestrict;
        
        NSDictionary *boundsMap = @{
            @"bounds" : @(bounds),
            @"boundsMode" : @(boundsMode),
        };
        
        return boundsMap;
    }

    NSDictionary *boundsMap = @{
        @"bounds" : @(nil),
        @"boundsMode" : @(boundsMode),
    };
    
    return boundsMap;
}


@end

