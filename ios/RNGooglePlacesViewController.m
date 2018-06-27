#import "RNGooglePlacesViewController.h"
#import "NSMutableDictionary+GMSPlace.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>

@interface RNGooglePlacesViewController ()<GMSAutocompleteViewControllerDelegate, GMSPlacePickerViewControllerDelegate>
@end

@implementation RNGooglePlacesViewController
{
	RNGooglePlacesViewController *_instance;

	RCTPromiseResolveBlock _resolve;
	RCTPromiseRejectBlock _reject;
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

- (void)placePicker: (GMSPlacePickerViewController *) placePicker
       didPickPlace: (GMSPlace *) place
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];
    
    if (_resolve) {
        _resolve([NSMutableDictionary dictionaryWithGMSPlace:place]);
    }
}

- (void)placePicker: (GMSPlacePickerViewController *) placePicker
   didFailWithError: (NSError *) error
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];
    
    if (_reject) {
        _reject(@"E_PLACE_PICKER_ERROR", [error localizedDescription], nil);
    }
}

- (void)placePickerDidCancel: (GMSPlacePickerViewController *) placePicker
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];
    
    if (_reject) {
        _reject(@"E_USER_CANCELED", @"Search cancelled", nil);
    }
}

- (void)openPlacePickerModal: (GMSCoordinateBounds *)bounds
                    resolver: (RCTPromiseResolveBlock)resolve
					rejecter: (RCTPromiseRejectBlock)reject;
{
	_resolve = resolve;
	_reject = reject;

	GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:bounds];
    GMSPlacePickerViewController *viewController = [[GMSPlacePickerViewController alloc] initWithConfig:config];
    viewController.delegate = self;
    UIViewController *topController = [self getTopController];
    [topController presentViewController:viewController animated:YES completion:nil];
}


// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
	didAutocompleteWithPlace:(GMSPlace *)place 
{
    UIViewController *topController = [self getTopController];
    [topController dismissViewControllerAnimated:YES completion:nil];
	
	if (_resolve) {
        _resolve([NSMutableDictionary dictionaryWithGMSPlace:place]);
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
