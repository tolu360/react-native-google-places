import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import RNGooglePlaces from '@just-insure/react-native-google-places';

import { ARIZONA_BOUNDS } from './constants';

export default function App() {
  const getPlaces = async () => {
    try {
      await RNGooglePlaces.beginAutocompleteSession();
      const response = await RNGooglePlaces.getAutocompletePredictions(
        'Cactus road',
        {
          country: 'US',
          type: 'address',
          locationRestriction: ARIZONA_BOUNDS,
        }
      );
      console.log(response, 'xxxx');
    } catch (e) {
      console.log(e, 'eeee');
    }
  };

  React.useEffect(() => {
    getPlaces();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Search for gugu place</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
