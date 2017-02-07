
import React from 'react'

import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	static filterDefaults = {
		type: 'noFilter',
		country: ''
	}

	static boundsDefaults = {
		latitude: 0,
		longitude: 0
	}

	openAutocompleteModal(filterOptions = {}) {
		return RNGooglePlacesNative.openAutocompleteModal({...RNGooglePlaces.filterDefaults, ...filterOptions})
	}

	openPlacePickerModal(latLngBounds = {}) {
		return RNGooglePlacesNative.openPlacePickerModal({...RNGooglePlaces.boundsDefaults, ...latLngBounds})
	}

	getAutocompletePredictions(query, filterOptions = {}) {
		return RNGooglePlacesNative.getAutocompletePredictions(query, {...RNGooglePlaces.filterDefaults, ...filterOptions})
	}

	lookUpPlaceByID(placeID) {
		return RNGooglePlacesNative.lookUpPlaceByID(placeID)
	}
}

export default new RNGooglePlaces()
