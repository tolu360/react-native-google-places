#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

#import "RCTBridge.h"

@interface RNGooglePlacesViewController : UIViewController

@property(nonatomic, strong) RNGooglePlacesViewController *instance;

- (instancetype) init;

- (IBAction)openAutocompleteModal: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject;

@end
