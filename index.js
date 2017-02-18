
import React from 'react'

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
}

export default new RNGooglePlaces()