#import <UIKit/UIKit.h>
#import <GoogleMapsBase/GoogleMapsBase.h>
#import <GooglePlaces/GooglePlaces.h>

#import <React/RCTBridge.h>

@interface RNGooglePlacesViewController : UIViewController

@property(nonatomic, strong) RNGooglePlacesViewController *instance;

- (instancetype) init;
- (void)openAutocompleteModal: (GMSAutocompleteFilter *)autocompleteFilter
                  placeFields: (GMSPlaceField)selectedFields
                       bounds: (GMSCoordinateBounds *)autocompleteBounds
                     resolver: (RCTPromiseResolveBlock)resolve
                     rejecter: (RCTPromiseRejectBlock)reject;
@end
