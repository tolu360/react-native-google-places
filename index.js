
import React from 'react'

import { NativeModules } from 'react-native'

const RNGooglePlacesNative = NativeModules.RNGooglePlaces

class RNGooglePlaces {
	openAutocompleteModal() {
		return RNGooglePlacesNative.openAutocompleteModal()
	}
}

export default new RNGooglePlaces()
