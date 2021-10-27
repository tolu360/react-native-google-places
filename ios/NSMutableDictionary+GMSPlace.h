#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMapsBase/GoogleMapsBase.h>

@interface NSMutableDictionary (GMSPlace)

+ (instancetype)dictionaryWithGMSPlace:(GMSPlace*)place;

@end
