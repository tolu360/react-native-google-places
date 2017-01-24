#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import <GooglePlaces/GooglePlaces.h>

@interface RNGooglePlaces : NSObject <RCTBridgeModule>

- (GMSPlacesAutocompleteTypeFilter) getFilterType:(NSString *)type;

@end
  