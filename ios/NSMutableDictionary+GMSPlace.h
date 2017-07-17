#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>

@interface NSMutableDictionary (GMSPlace)

+ (instancetype)dictionaryWithGMSPlace:(GMSPlace*)place;

@end
