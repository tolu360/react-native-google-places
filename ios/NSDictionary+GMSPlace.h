#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>

@interface NSDictionary (GMSPlace)

+ (instancetype)dictionaryWithGMSPlace:(GMSPlace*)place;

@end
