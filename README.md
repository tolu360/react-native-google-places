# react-native-google-places
iOS/Android Google Places Widgets (Autocomplete, Place Picker) for React Native Apps

## Shots

<img width=200 title="Modal Open - iOS" src="./shots/modal-open-ios.png">
<img width=200 title="Modal in Search - iOS" src="./shots/modal-in-search-ios.png">
<img width=200 title="Modal Open - Android" src="./shots/modal-open-android.png">
<img width=200 title="Modal in Search - Android" src="./shots/modal-in-search-android.png">

## Install

```
npm i react-native-google-places --save
react-native link react-native-google-places
```


#### Google Places API Set-Up
1. Sign up for [Google Places API for Android in Google API Console](https://console.developers.google.com/flows/enableapi?apiid=placesandroid&reusekey=true) to grab your Android API key (not browser key).
2. Read further API setup guides at [https://developers.google.com/places/android-api/signup](https://developers.google.com/places/android-api/signup).
3. Similarly, sign up for [Google Places API for iOS in Google API Console](https://console.developers.google.com/flows/enableapi?apiid=placesios&reusekey=true) to grab your iOS API key (not browser key).
4. Ensure you check out further guides at [https://developers.google.com/places/ios-api/start](https://developers.google.com/places/ios-api/start).
5. With both keys in place, you can proceed.

#### Post-install Steps

##### iOS (with Cocoapods)

- In XCode's "Project navigator", right click on project name folder ➜ Add Files to <...>. Ensure `Copy items if needed and Create groups` are checked. Go to node_modules ➜ react-native-google-places ➜ add `ios` folder (this step may not be required if running `react-native link` already worked for you).
- Add `pod 'GooglePlaces'` and `pod 'GoogleMaps'` to your Podfile.
- If you are not using Cocoapods in your project already, run `cd ios && pod init` at the root directory of your project. Otherwise just edit your Podfile to include:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

target 'YOUR_APP_TARGET_NAME' do

  pod 'GooglePlaces'
  pod 'GoogleMaps'

end
```
- In your AppDelegate.m file, import the Google Places library by adding `@import GooglePlaces;` on top of the file.
- Within the `didFinishLaunchingWithOptions` method, instantiate the library as follows:

```Objective-C
[GMSPlacesClient provideAPIKey:@"YOUR_IOS_API_KEY_HERE"];
```
- By now, you should be all set to install the packages from your Podfile. Run `pod install` from your `ios` directory.
- Close Xcode, and then open (double-click) your project's .xcworkspace file to launch Xcode. From this time onwards, you must use the `.xcworkspace` file to open the project. Or just use the `react-native run-ios` command as usual to run your app in the simulator.

##### Android
- In your AndroidManifest.xml file add your API key in a meta-data tag (ensure you are within the <application> tag as follows:

```xml
<meta-data
	android:name="com.google.android.geo.API_KEY"
	android:value="YOUR_ANDROID_API_KEY_HERE"/>
```
- The following additional setup steps are optional as they should have been taken care of, for you when you ran `react-native link react-native-google-places`. Otherwise, do the following or just ensure they are in place;
- Add the following in your `android/settings.gradle` file:

```java
include ':react-native-google-places'
project(':react-native-google-places').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-google-places/android')
```
- Add the following in your `android/app/build.grade` file:

```java
dependencies {
    ...
    compile project(':react-native-google-places')
}
```
- Add the following in your `...MainApplication.java` file:

```java
import com.arttitude360.reactnative.rngoogleplaces.RNGooglePlacesPackage;

@Override
protected List<ReactPackage> getPackages() {
  return Arrays.<ReactPackage>asList(
      new MainReactPackage(),
      ...
      new RNGooglePlacesPackage() //<-- Add line
  );
}
```
- Finally, we can run `react-native run-android` to get started.


## Usage

### Autocomplete Modal: Allows your users to enter place names and addresses - and autocompletes your users' queries as they type.

#### Import library

```javascript
import RNGooglePlaces from 'react-native-google-places';
```

#### Open Autocomplete Modal (e.g as Callback to an onPress event)


```javascript
class GPlacesDemo extends Component {
  openSearchModal() {
    RNGooglePlaces.openAutocompleteModal()
    .then((place) => { 
		console.log(place); 		
		// place represents user's selection from the
		// suggestions and it is a simplified Google Place object.
    })
    .catch((error) => console.log(error));
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity
          style={styles.button}
          onPress={() => this.openSearchModal()}
        >
          <Text>Pick a Place</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```

#### Example Response from the Autocomplete Modal
```javascript
{ 
	placeID: "ChIJZa6ezJa8j4AR1p1nTSaRtuQ", 
	website: "https://www.facebook.com/", 
	phoneNumber: "+1 650-543-4800", 
	address: "1 Hacker Way, Menlo Park, CA 94025, USA", 
	name: "Facebook HQ",
	latitude: 37.4843428,
	longitude: -122.14839939999999
}
```
- Note: The keys available from the response from the resolved `Promise` from calling `RNGooglePlaces.openAutocompleteModal()` are dependent on the selected place - as `phoneNumber, website` are not set on all `Google Place` objects.

#### Open PlacePicker Modal (WIP)
- To be implemented subsequently.

### Troubleshooting

#### On iOS
You have to link dependencies and re-run the build :

1. Run `react-native link`
2. In XCode's "Project navigator", right click on project name folder ➜ Add Files to <...>. Ensure `Copy items if needed and Create groups` are checked. Go to node_modules ➜ react-native-google-places ➜ add `ios` folder (this step may not be required if running `react-native link` already worked for you).
3. Run `react-native run-ios`

#### On Android
1. Run "android" and make sure every packages is updated.
2. If not installed yet, you have to install the following packages:


- Extras / Google Play services
- Extras / Google Repository
- Android (API 23+) / Google APIs Intel x86 Atom System Image Rev. 13
- Check manual installation steps

## License
The MIT License.



