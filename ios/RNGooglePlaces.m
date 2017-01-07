
#import "RNGooglePlaces.h"
#import <React/RCTBridge.h>
#import "RNGooglePlacesViewController.h"
#import <React/RCTRootView.h>
#import <React/RCTLog.h>

#import <GooglePlaces/GooglePlaces.h>

@implementation RNGooglePlaces

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(openAutocompleteModal: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
	@try {
		RNGooglePlacesViewController* a = [[RNGooglePlacesViewController alloc] init];
		[a openAutocompleteModal: resolve rejecter: reject];
	}
	@catch (NSException * e) {
    reject(@"E_OPEN_FAILED", @"Could not open modal", [self errorFromException:e]);
  }
}

RCT_EXPORT_METHOD(openPlacePickerModal: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
  @try {
    RNGooglePlacesViewController* a = [[RNGooglePlacesViewController alloc] init];
    [a openPlacePickerModal: resolve rejecter: reject];
  }
  @catch (NSException * e) {
    reject(@"E_OPEN_FAILED", @"Could not open modal", [self errorFromException:e]);
  }
}

- (NSError *) errorFromException: (NSException *) exception
{
    NSDictionary *exceptionInfo = @{
        @"name": exception.name,
        @"reason": exception.reason,
        @"callStackReturnAddresses": exception.callStackReturnAddresses,
        @"callStackSymbols": exception.callStackSymbols,
        @"userInfo": exception.userInfo
    };

    return [[NSError alloc] initWithDomain: @"RNGooglePlaces"
                                      code: 0
                                  userInfo: exceptionInfo];
}


@end
  
  
