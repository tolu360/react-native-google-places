#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

#import <React/RCTBridge.h>

@interface RNGooglePlacesViewController : UIViewController

@property(nonatomic, strong) RNGooglePlacesViewController *instance;

- (instancetype) init;

- (void)openAutocompleteModal: (GMSAutocompleteFilter *)autocompleteFilter
                       bounds: (GMSCoordinateBounds *)bounds
                     resolver: (RCTPromiseResolveBlock)resolve
                     rejecter: (RCTPromiseRejectBlock)reject;
- (void)openPlacePickerModal: (GMSCoordinateBounds *)bounds
					resolver: (RCTPromiseResolveBlock)resolve
                  	rejecter: (RCTPromiseRejectBlock)reject;

@end
