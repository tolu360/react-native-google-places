
import React from 'react'

import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	openAutocompleteModal() {
		return RNGooglePlacesNative.openAutocompleteModal()
	}

	openPlacePickerModal() {
		return RNGooglePlacesNative.openPlacePickerModal()
	}
}

export default new RNGooglePlaces()
