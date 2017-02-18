#import "RNGooglePlacesViewController.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>

@interface RNGooglePlacesViewController ()<GMSAutocompleteViewControllerDelegate>
@end

@implementation RNGooglePlacesViewController
{
	RNGooglePlacesViewController *_instance;

	RCTPromiseResolveBlock _resolve;
	RCTPromiseRejectBlock _reject;
	GMSPlacePicker *_placePicker;
}

- (instancetype)init 
{
	self = [super init];
	_instance = self;

	return self;
}

- (void)openAutocompleteModal: (GMSAutocompleteFilter *)autocompleteFilter
                       bounds: (GMSCoordinateBounds *)bounds
                     resolver: (RCTPromiseResolveBlock)resolve
                     rejecter: (RCTPromiseRejectBlock)reject;
{
    _resolve = resolve;
    _reject = reject;
    
    GMSAutocompleteViewController *viewController = [[GMSAutocompleteViewController alloc] init];
    viewController.autocompleteFilter = autocompleteFilter;
    viewController.autocompleteBounds = bounds;
	viewController.delegate = self;
    UIViewController *topController = [self getTopController];
	[topController presentViewController:viewController animated:YES completion:nil];
}

- (void)openPlacePickerModal: (GMSCoordinateBounds *)bounds
                    resolver: (RCTPromiseResolveBlock)resolve
					rejecter: (RCTPromiseRejectBlock)reject;
{
	_resolve = resolve;
	_reject = reject;

	GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:bounds];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (place) {
            if (_resolve) {
		        NSMutableDictionary *placeData =[[NSMutableDictionary alloc] init];
		        placeData[@"name"] = place.name;
		        placeData[@"address"] = place.formattedAddress;
		        placeData[@"attributions"] = place.attributions.string;
		        placeData[@"latitude"] = [NSNumber numberWithDouble:place.coordinate.latitude];
		        placeData[@"longitude"] = [NSNumber numberWithDouble:place.coordinate.longitude];
		        placeData[@"phoneNumber"] = place.phoneNumber;
		        placeData[@"website"] = place.website.absoluteString;
		        placeData[@"placeID"] = place.placeID;
                placeData[@"types"] = place.types;

            NSMutableDictionary *addressComponents =[[NSMutableDictionary alloc] init];
            for( int i=0;i<place.addressComponents.count;i++) {
              addressComponents[place.addressComponents[i].type] = place.addressComponents[i].name;
            }
            placeData[@"addressComponents"] = addressComponents;

		        _resolve(placeData);
		    }
        } else if (error) {
            _reject(@"E_PLACE_PICKER_ERROR", [error localizedDescription], nil);

        } else {
            _reject(@"E_USER_CANCELED", @"Search cancelled", nil);
        }
    }];
}


// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
	didAutocompleteWithPlace:(GMSPlace *)place 
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];
	
	if (_resolve) {
        NSMutableDictionary *placeData =[[NSMutableDictionary alloc] init];
        placeData[@"name"] = place.name;
        placeData[@"address"] = place.formattedAddress;
        placeData[@"attributions"] = place.attributions.string;
        placeData[@"latitude"] = [NSNumber numberWithDouble:place.coordinate.latitude];
        placeData[@"longitude"] = [NSNumber numberWithDouble:place.coordinate.longitude];
        placeData[@"phoneNumber"] = place.phoneNumber;
        placeData[@"website"] = place.website.absoluteString;
        placeData[@"placeID"] = place.placeID;
        placeData[@"types"] = place.types;

        NSMutableDictionary *addressComponents =[[NSMutableDictionary alloc] init];
        for( int i=0;i<place.addressComponents.count;i++) {
          addressComponents[place.addressComponents[i].type] = place.addressComponents[i].name;
        }
        placeData[@"addressComponents"] = addressComponents;

        _resolve(placeData);
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
	didFailAutocompleteWithError:(NSError *)error 
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];

	// TODO: handle the error.
	NSLog(@"Error: %@", [error description]);

	_reject(@"E_AUTOCOMPLETE_ERROR", [error description], nil);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController 
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];

	_reject(@"E_USER_CANCELED", @"Search cancelled", nil);
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController 
{
  	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController 
{
  	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// User canceled the operation.
- (UIViewController *)getTopController
{
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController) { topController = topController.presentedViewController; }
    return topController;
}

@end
