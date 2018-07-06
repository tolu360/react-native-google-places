import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	static filterDefaults = {
		type: 'noFilter',
		country: '',
		useOverlay: false
	}

	static boundsDefaults = {
		latitude: 0,
		longitude: 0,
		radius: 0.1
	}

	openAutocompleteModal(filterOptions = {}) {
		return RNGooglePlacesNative.openAutocompleteModal({
			...RNGooglePlaces.filterDefaults,
            ...RNGooglePlaces.boundsDefaults,
			...filterOptions
		})
	}

	openPlacePickerModal(latLngBounds = {}) {
		return RNGooglePlacesNative.openPlacePickerModal({
            ...RNGooglePlaces.boundsDefaults,
		    ...latLngBounds
        })
	}

	getAutocompletePredictions(query, filterOptions = {}) {
		return RNGooglePlacesNative.getAutocompletePredictions(query, {
            ...RNGooglePlaces.filterDefaults,
            ...RNGooglePlaces.boundsDefaults,
			...filterOptions
		})
	}

	lookUpPlaceByID(placeID) {
	    return RNGooglePlacesNative.lookUpPlaceByID(placeID)
	}

	lookUpPlacesByIDs(placeIDs) {
	    return RNGooglePlacesNative.lookUpPlacesByIDs(placeIDs)
	}

	getCurrentPlace() {
		return RNGooglePlacesNative.getCurrentPlace()
	}

	async getPlacePhotos(placeID) {
		const photos = await RNGooglePlacesNative.getPlacePhotos(placeID)
		return photos.map((photo, idx) => ({photoID: idx, ...photo}))
	}

	getPlacePhoto({placeID, photoID}) {
		return RNGooglePlacesNative.getPlacePhoto(placeID, photoID)
	}

	getScaledPlacePhoto({placeID, photoID}, width, height) {
		return RNGooglePlacesNative.getScaledPlacePhoto(placeID, photoID, width, height)
	}
}

export default new RNGooglePlaces()
