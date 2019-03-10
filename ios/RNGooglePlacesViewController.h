#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

#import <React/RCTBridge.h>

@interface RNGooglePlacesViewController : UIViewController

@property(nonatomic, strong) RNGooglePlacesViewController *instance;

- (instancetype) init;

- (void)openAutocompleteModal: (GMSAutocompleteFilter *)autocompleteFilter
                  placeFields: (GMSPlaceField)selectedFields
                       bounds: (GMSCoordinateBounds *)autocompleteBounds
                   boundsMode: (GMSAutocompleteBoundsMode)autocompleteBoundsMode
                     resolver: (RCTPromiseResolveBlock)resolve
                     rejecter: (RCTPromiseRejectBlock)reject;
                     

@end
