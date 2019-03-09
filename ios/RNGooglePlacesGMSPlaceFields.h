#import <GooglePlaces/GooglePlaces.h>

static NSDictionary<NSString *, NSNumber *> *const fieldsMapping = @{
    @"name" : @(GMSPlaceFieldName),
    @"placeID" : @(GMSPlaceFieldPlaceID),
    @"plusCode" : @(GMSPlaceFieldPlusCode),
    @"location" : @(GMSPlaceFieldCoordinate),
    @"openingHours" : @(GMSPlaceFieldOpeningHours),
    @"phoneNumber" : @(GMSPlaceFieldPhoneNumber),
    @"address" : @(GMSPlaceFieldFormattedAddress),
    @"rating" : @(GMSPlaceFieldRating),
    @"userRatingsTotal" : @(GMSPlaceFieldUserRatingsTotal),
    @"priceLevel" : @(GMSPlaceFieldPriceLevel),
    @"types" : @(GMSPlaceFieldTypes),
    @"website" : @(GMSPlaceFieldWebsite),
    @"viewport" : @(GMSPlaceFieldViewport),
    @"addressComponents" : @(GMSPlaceFieldAddressComponents),
    @"photos" : @(GMSPlaceFieldPhotos),
};