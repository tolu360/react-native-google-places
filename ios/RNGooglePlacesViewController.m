#import "RNGooglePlacesViewController.h"

#import <GooglePlaces/GooglePlaces.h>
#import "RCTUtils.h"
#import "RCTLog.h"

@interface RNGooglePlacesViewController ()<GMSAutocompleteViewControllerDelegate>
@end

@implementation RNGooglePlacesViewController
{
	RNGooglePlacesViewController *instance;

	RCTPromiseResolveBlock _resolve;
	RCTPromiseRejectBlock _reject;
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
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	[rootViewController presentViewController:viewController animated:YES completion:nil];
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
