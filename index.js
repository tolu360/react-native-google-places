
import React from 'react'

import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	openAutocompleteModal(filterType='noFilter') {
		return RNGooglePlacesNative.openAutocompleteModal(filterType)
	}

	openPlacePickerModal() {
		return RNGooglePlacesNative.openPlacePickerModal()
	}

	getAutocompletePredictions(query, filterType = 'noFilter') {
		return RNGooglePlacesNative.getAutocompletePredictions(query, filterType)
	}

	lookUpPlaceByID(placeID) {
		return RNGooglePlacesNative.lookUpPlaceByID(placeID)
	}
}

export default new RNGooglePlaces()
