
#import "RNGooglePlaces.h"
#import <React/RCTBridge.h>
#import "RNGooglePlacesViewController.h"
#import "RCTConvert+RNGPAutocompleteTypeFilter.h"
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
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    @try {
        GMSCoordinateBounds *bounds = [self getBounds:options];
        
        GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
        autocompleteFilter.type = [self getFilterType:[RCTConvert NSString:options[@"type"]]];
        autocompleteFilter.country = [options[@"country"] length] == 0? nil : options[@"country"];
        RNGooglePlacesViewController* a = [[RNGooglePlacesViewController alloc] init];
        [a openAutocompleteModal: autocompleteFilter bounds: bounds resolver: resolve rejecter: reject];
    }
    @catch (NSException * e) {
        reject(@"E_OPEN_FAILED", @"Could not open modal", [self errorFromException:e]);
    }
}

RCT_EXPORT_METHOD(openPlacePickerModal: (NSDictionary *)options
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    @try {
        GMSCoordinateBounds *bounds = [self getBounds:options];
        
        RNGooglePlacesViewController* a = [[RNGooglePlacesViewController alloc] init];
        [a openPlacePickerModal: bounds resolver: resolve rejecter: reject];
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
    GMSCoordinateBounds *bounds = [self getBounds:options];
    
    [[GMSPlacesClient sharedClient] autocompleteQuery:query
                                               bounds:bounds
                                               filter:autocompleteFilter
                                             callback:^(NSArray *results, NSError *error) {
                                                 if (error != nil) {
                                                     reject(@"E_AUTOCOMPLETE_ERROR", [error description], nil);
                                                     return;
                                                 }
                                                 
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
                                             }];
}

RCT_REMAP_METHOD(lookUpPlaceByID,
                 placeID: (NSString*)placeID
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject)
{
    [[GMSPlacesClient sharedClient] lookUpPlaceID:placeID
                                         callback:^(GMSPlace *place, NSError *error) {
                                             if (error != nil) {
                                                 reject(@"E_PLACE_DETAILS_ERROR", [error localizedDescription], nil);
                                                 return;
                                             }
                                             
                                             if (place != nil) {
                                                 NSMutableDictionary *placeData =[[NSMutableDictionary alloc] init];
                                                 placeData[@"name"] = place.name;
                                                 placeData[@"address"] = place.formattedAddress;
                                                 placeData[@"attributions"] = place.attributions.string;
                                                 placeData[@"latitude"] = [NSNumber numberWithDouble:place.coordinate.latitude];
                                                 placeData[@"longitude"] = [NSNumber numberWithDouble:place.coordinate.longitude];
                                                 placeData[@"phoneNumber"] = place.phoneNumber;
                                                 placeData[@"website"] = place.website.absoluteString;
                                                 placeData[@"placeID"] = place.placeID;
                                                 placeData[@"types"] = place.types;
                                                 
                                                 NSMutableDictionary *addressComponents =[[NSMutableDictionary alloc] init];
                                                 for( int i=0;i<place.addressComponents.count;i++) {
                                                     addressComponents[place.addressComponents[i].type] = place.addressComponents[i].name;
                                                 }
                                                 placeData[@"addressComponents"] = addressComponents;
                                                 
                                                 resolve(placeData);
                                             } else {
                                                 resolve(@{});
                                             }
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

- (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord: (CLLocationCoordinate2D)fromCoord
                                 atDistanceKm: (double)distanceKm
                             atBearingDegrees: (double)bearingDegrees
{
    double distanceRadians = distanceKm / 6371.0; //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}

- (GMSCoordinateBounds *)getBounds: (NSDictionary *)fromOptions
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = (CLLocationDegrees) [[RCTConvert NSNumber:fromOptions[@"latitude"]] doubleValue];
    coordinate.longitude = (CLLocationDegrees) [[RCTConvert NSNumber:fromOptions[@"longitude"]] doubleValue];
    double radius = [[RCTConvert NSNumber:fromOptions[@"radius"]] doubleValue];
    GMSCoordinateBounds *bounds = nil;
    
    if (coordinate.latitude != 0 && coordinate.longitude != 0 && radius != 0) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        CLLocationCoordinate2D northEast = [self coordinateFromCoord:center atDistanceKm:radius atBearingDegrees:45];
        CLLocationCoordinate2D southWest = [self coordinateFromCoord:center atDistanceKm:radius atBearingDegrees:225];
        bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    }
    return bounds;
}


@end

