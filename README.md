# hapramp-assignment

This repository contains the source code for the iOS app assignment given by Hapramp as part of their hiring process.

<p align="center">
  <img src="https://github.com/DhruvSaraswat/hapramp-assignment/blob/develop/assignment/assignment/Resources/README_Static_Resources/Initial_GIF.gif">
</p>

# Get Started
1. Clone this repository.
2. Open the <a href="https://github.com/DhruvSaraswat/hapramp-assignment/tree/main/assignment/assignment.xcodeproj">assignment.xcodeproj</a> file in <a href="https://developer.apple.com/xcode/ide/">Xcode IDE</a>.
3. Click on the "Play" button on the top-left-hand-corner of Xcode.

To run all the unit tests, press Command ⌘ + control ⌃ + U.

# In-app Navigation
1. The user opens the application and sees the splash screen.
2. Then they go to the image listing view which is infinitely scrollable using pagination.
3. The banner on the top of the image listing view shows a random image from the random photo API.
4. Users can see the latest photos by using swipe-refresh.
5. On clicking on an image in the list view, the user goes to the image detail view. This is where they see the full image, along with some other relevant details about the image.

# Notes for Each Screen
## Splash Screen
The <a href="https://github.com/DhruvSaraswat/hapramp-assignment/blob/main/assignment/assignment/Base.lproj/LaunchScreen.storyboard">LaunchScreen.storyboard</a> file is used to setup the launch screen of the app.

## Image List Screen
<ul>
  <li>This screen shows random images fetched from the <a href="https://unsplash.com/documentation#get-a-random-photo">Get Random Photos Unsplash API</a>. This API returns 5 URLs (raw, full, regular, small and thumb) for each image along with a <a href="https://github.com/woltapp/blurhash">blurHash</a> string. The regular sized image is shown in the Image List screen.</li><br>
  <li>The images are fetched page-by-page as the user scrolls downwards, and displayed in an infinite scroll. The page sized used in this app is 10.</li><br>
  <li>A <a href="https://developer.apple.com/documentation/uikit/uicollectionview">UICollectionView</a> is used to display the images.</li><br>
  <li>The first image in the screen is covered by a dark overlay, and the "DOSPLASH" label text is shown on top of it.</li><br>
  <li>Clicking on any image will take the user to the Image Details screen, where the full-sized image will be displayed.</li><br>
  <li>If / when the user swipes to refresh the screen, a new set of images will be fetched, and the page count will be reset to 1.</li><br>
</ul>
<p align="center">
  <img src="https://github.com/DhruvSaraswat/hapramp-assignment/blob/develop/assignment/assignment/Resources/README_Static_Resources/Swipe_to_Refresh_Demo.gif">
</p>
<ul>
  <li>In case there is any error while fetching an image, an alert will be displayed.</li><br>
</ul>
<p align="center">
  <img src="https://github.com/DhruvSaraswat/hapramp-assignment/blob/develop/assignment/assignment/Resources/README_Static_Resources/Image_List_Error.gif">
</p>
<ul>
  <li>When the user reaches the end of the image list, a label saying "You have reached the end of the list." will be displayed.</li><br>
</ul>
<p align="center">
  <img src="https://github.com/DhruvSaraswat/hapramp-assignment/blob/develop/assignment/assignment/Resources/README_Static_Resources/End_Of_List_Demo.gif">
</p>

### Optimizations Done in this Screen
<ul>
<li>The data is <a href="https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching/1771767-collectionview">pre-fetched</a> to prepare the data for the cells just outside the viewport of the iOS device.</li><br>
<li>The regular-sized image and user profile image for each cell is fetched asynchronously (so that the main UI thread of the app is not blocked) and <a href="https://developer.apple.com/documentation/foundation/nscache">cached</a>.</li><br>
<li>While the regular-sized image is being fetched, the <a href="https://github.com/woltapp/blurhash">blurHash</a> string is used to generate and show a placeholder image and a <a href="https://developer.apple.com/documentation/uikit/uiactivityindicatorview">loader</a> is shown in the center of the image.</li><br>
</ul>

## Image Details Screen
When the user clicks on any iamge in the Image List screen, they would be led to the Image Details screen which shows the full image along with a few relevant image details. The data shown in this screen has already been fetched in the previous Image List Screen via the <a href="https://unsplash.com/documentation#get-a-random-photo">Get Random Photos Unsplash API</a>. Fetching the the full-sized image is the only network request which is performed in this screen.
<ul>
<li>The full-sized image shown in this screen is scaled based on its dimensions (which means variable height of the screen), because of which the contents of this screen are embedded in a <a href="https://developer.apple.com/documentation/uikit/uiscrollview">UIScrollView</a>.</li><br>
</ul>

### Optimizations Done in this Screen
<ul>
<li>The full-sized image takes time to fully load. While it is being fetched asynchronously, the <a href="https://github.com/woltapp/blurhash">blurHash</a> string is used to generate and display a placeholder image, and then if the regular-sized image has already been downloaded and stored in the cache in the Image List Screen, it is displayed as a placeholder image here. Till the full-sized image is fetched, a <a href="https://developer.apple.com/documentation/uikit/uiactivityindicatorview">loader</a> is shown in the center of the image.</li><br>
<li>If the user clicks on the "Close" button to navigate to the previous screen and the full-sized image is not yet fully loaded, the download is cancelled to prevent unnecessary network bandwidth usage.</li>
</ul>


# Miscellaneous Notes
<ul>
  <li>VIPER architecture is used in this assignment, to make unit testing easier, and to follow SOLID principles.</li><br>
  <li>All the unit tests are inside the asignment-tests folder.</li><br>
  <li>There are no UI tests in this assignment, since testing the UI would involve hitting the Unsplash APIs in the Image List screen, which would count against the <a href="https://unsplash.com/documentation#rate-limiting">quota of 50 API requests per hour set by Unsplash</a>.
    A better way to write UI Tests would be to use a tool like <a href="http://wiremock.org/">WireMock</a> to store and mock all the Unsplash PI responses in a local server, and then hit that local server (instead of the actual Unsplash APIs) while running UI tests. However, this is a time-consuming activity.</li><br>
  <li>Both the regular sized and full sized images are loaded asynchronously and cached to improve app performance, so that the actual images have to be fetched over the network only once.</li><br>
  <li>This app works in both Portrait and Landscape modes.</li>
</ul>
<p align="center">
  <img src="https://github.com/DhruvSaraswat/hapramp-assignment/blob/develop/assignment/assignment/Resources/README_Static_Resources/Landscape_Mode_Demo.gif">
</p>
<ul>
  <li>This app supports iOS 13.0 and above.</li>
</ul>
