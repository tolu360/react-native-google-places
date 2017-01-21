#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

#import <React/RCTBridge.h>

@interface RNGooglePlacesViewController : UIViewController

@property(nonatomic, strong) RNGooglePlacesViewController *instance;

- (instancetype) init;

- (void)openAutocompleteModal: (GMSPlacesAutocompleteTypeFilter)filter
                     resolver: (RCTPromiseResolveBlock)resolve
                     rejecter: (RCTPromiseRejectBlock)reject;
- (IBAction)openPlacePickerModal: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject;

@end
