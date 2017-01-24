
import React from 'react'

import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	static filterDefaults = {
		type: 'noFilter',
		country: ''
	}

	openAutocompleteModal(filterOptions = {}) {
		return RNGooglePlacesNative.openAutocompleteModal({...RNGooglePlaces.filterDefaults, ...filterOptions})
	}

	openPlacePickerModal() {
		return RNGooglePlacesNative.openPlacePickerModal()
	}

	getAutocompletePredictions(query, filterOptions = {}) {
		return RNGooglePlacesNative.getAutocompletePredictions(query, {...RNGooglePlaces.filterDefaults, ...filterOptions})
	}

	lookUpPlaceByID(placeID) {
		return RNGooglePlacesNative.lookUpPlaceByID(placeID)
	}
}

export default new RNGooglePlaces()
