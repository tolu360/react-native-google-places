#import "NSMutableDictionary+GMSPlace.h"

@implementation NSMutableDictionary (GMSPlace)

+ (instancetype)dictionaryWithGMSPlace:(GMSPlace*)place
{
    NSMutableDictionary *placeData = [[NSMutableDictionary alloc] init];
    
    if (place.name) {
        placeData[@"name"] = place.name;
    }

    if (place.formattedAddress) {
        placeData[@"address"] = place.formattedAddress;
    }

    placeData[@"attributions"] = place.attributions.string;

    if (place.coordinate.latitude) {
        NSMutableDictionary *locationMap = [[NSMutableDictionary alloc] init];
        locationMap[@"latitude"] = [NSNumber numberWithDouble:place.coordinate.latitude];
        locationMap[@"longitude"] = [NSNumber numberWithDouble:place.coordinate.longitude];

        placeData[@"location"] = locationMap;
    }

    if (place.phoneNumber) {
        placeData[@"phoneNumber"] = place.phoneNumber;
    }

    if (place.website) {
        placeData[@"website"] = place.website.absoluteString;
    }

    if (place.placeID) {
        placeData[@"placeID"] = place.placeID;
    }

    if (place.types) {
        placeData[@"types"] = place.types;
    }

    if (place.priceLevel) {
        placeData[@"priceLevel"] = [NSNumber numberWithInteger:place.priceLevel];
    }

    if (place.rating) {
        placeData[@"rating"] = [NSNumber numberWithDouble:place.rating];
    }
    
    if (place.viewport) {
        NSMutableDictionary *viewportMap = [[NSMutableDictionary alloc] init];
        viewportMap[@"latitudeNE"] = [NSNumber numberWithDouble:place.viewport.northEast.latitude];
        viewportMap[@"longitudeNE"] = [NSNumber numberWithDouble:place.viewport.northEast.longitude];
        viewportMap[@"latitudeSW"] = [NSNumber numberWithDouble:place.viewport.southWest.latitude];
        viewportMap[@"longitudeSW"] = [NSNumber numberWithDouble:place.viewport.southWest.longitude];

        placeData[@"viewport"] = viewportMap;
    }

    if (place.plusCode) {
        NSMutableDictionary *plusCodeMap = [[NSMutableDictionary alloc] init];
        plusCodeMap[@"globalCode"] = place.plusCode.globalCode;
        plusCodeMap[@"compoundCode"] = place.plusCode.compoundCode;

        placeData[@"placeCode"] = plusCodeMap;
    }
    
    if (place.addressComponents) {
        NSMutableArray *addressComponents = [[NSMutableArray alloc] init];
        for( int i=0;i<place.addressComponents.count;i++) {
            NSMutableDictionary *addressComponent = [[NSMutableDictionary alloc] init];
            addressComponent[@"types"] = place.addressComponents[i].types;
            addressComponent[@"name"] = place.addressComponents[i].name;
            addressComponent[@"shortName"] = place.addressComponents[i].shortName;
            
            [addressComponents addObject:addressComponent];
        }
        
        placeData[@"addressComponents"] = addressComponents;
    }

    if (place.openingHours) {
        placeData[@"openingHours"] = place.openingHours.weekdayText;
    }

    if (place.userRatingsTotal) {
        placeData[@"userRatingsTotal"] = @(place.userRatingsTotal);
    }
    
    return placeData;
}

@end
