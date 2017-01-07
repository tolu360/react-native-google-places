#import "RNGooglePlacesViewController.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>

@interface RNGooglePlacesViewController ()<GMSAutocompleteViewControllerDelegate>
@end

@implementation RNGooglePlacesViewController
{
	RNGooglePlacesViewController *instance;

	RCTPromiseResolveBlock _resolve;
	RCTPromiseRejectBlock _reject;
	GMSPlacePicker *_placePicker;
}

- (instancetype)init 
{
	self = [super init];
	instance = self;

	return self;
}

- (void)openAutocompleteModal: (RCTPromiseResolveBlock)resolve
					 rejecter: (RCTPromiseRejectBlock)reject;
{
	_resolve = resolve;
	_reject = reject;
	GMSAutocompleteViewController *viewController = [[GMSAutocompleteViewController alloc] init]; 
	viewController.delegate = self; 
	UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController; 
	while (topController.presentedViewController) { topController = topController.presentedViewController; } 
	[topController presentViewController:viewController animated:YES completion:nil];
}

- (void)openPlacePickerModal: (RCTPromiseResolveBlock)resolve
					 rejecter: (RCTPromiseRejectBlock)reject;
{
	_resolve = resolve;
	_reject = reject;

	GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
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
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	[rootViewController dismissViewControllerAnimated:YES completion:nil];
	// Do something with the selected place.
	NSLog(@"Place name %@", place.name);
	NSLog(@"Place address %@", place.formattedAddress);
	NSLog(@"Place attributions %@", place.attributions.string);

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
        
        _resolve(placeData);
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
	didFailAutocompleteWithError:(NSError *)error 
{
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	[rootViewController dismissViewControllerAnimated:YES completion:nil];
	// TODO: handle the error.
	NSLog(@"Error: %@", [error description]);

	_reject(@"E_AUTOCOMPLETE_ERROR", [error description], nil);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController 
{
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	[rootViewController dismissViewControllerAnimated:YES completion:nil];

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

@end
