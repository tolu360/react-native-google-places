#import "NSMutableDictionary+GMSPlace.h"

@implementation NSMutableDictionary (GMSPlace)

+ (instancetype)dictionaryWithGMSPlace:(GMSPlace*)place
{
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
    placeData[@"priceLevel"] = [NSNumber numberWithInteger:place.priceLevel];
    placeData[@"rating"] = [NSNumber numberWithDouble:place.rating];
    
    if (place.viewport) {
        placeData[@"north"] = [NSNumber numberWithDouble:place.viewport.northEast.latitude];
        placeData[@"east"] = [NSNumber numberWithDouble:place.viewport.northEast.longitude];
        placeData[@"south"] = [NSNumber numberWithDouble:place.viewport.southWest.latitude];
        placeData[@"west"] = [NSNumber numberWithDouble:place.viewport.southWest.longitude];
    }
    
    NSMutableDictionary *addressComponents =[[NSMutableDictionary alloc] init];
    for( int i=0;i<place.addressComponents.count;i++) {
        addressComponents[place.addressComponents[i].type] = place.addressComponents[i].name;
    }
    placeData[@"addressComponents"] = addressComponents;
    
    return placeData;
}

@end
