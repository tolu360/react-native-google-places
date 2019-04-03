#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

#import <GooglePlaces/GooglePlaces.h>

@interface RNGooglePlaces : NSObject <RCTBridgeModule>

- (GMSPlacesAutocompleteTypeFilter) getFilterType:(NSString *)type;
- (GMSPlaceField) getSelectedFields:(NSArray *)fields isCurrentOrFetchPlace:(Boolean)currentOrFetch;
- (GMSCoordinateBounds *) getBounds: (NSDictionary *)biasOptions andRestrictOptions: (NSDictionary *)restrictOptions;

@end
  