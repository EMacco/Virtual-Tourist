# Virtual-Tourist
This app allows you to virtually tour any place on the planet! Simply drop a pin anywhere on the map, and instantly browse nearby Flickr photos. It’s like you’re really there...or something.

# Features

  - Persist user map configuration to Plist
  - User can place pin on Map by using the touch and hold gesture
  - When a pin is selected, download images for the pin location using the `Flickr API`
  - Images and Pin location are persisted using `Core Data`
  - User can delete saved pins and images
  - User can reload a location's image collection

# Installation
Clone the repository
```sh
$ git clone https://github.com/EMacco/Virtual-Tourist.git
$ cd Virtual-Tourist
```

### Get Flickr Key
- Login or Create an account with [Flickr](https://www.flickr.com)
- Generate an API Key [Apply](https://www.flickr.com/services/apps/create/apply)
- Copy the Key

### Run the application

- Open the file `Virtual-Tourist.xcworkspace` using Xcode
- Navigate to `VirtualTourist/Models/Network/Network Requests/FlickrParams.swift`
- Add your Flickr key between empty quotes `""` line 13
- Click on the play button at the top left corner to build and run the project

### Screenshot
<img width="522" alt="Screenshot 2020-01-20 at 15 08 47" src="https://user-images.githubusercontent.com/20377428/72739957-02276400-3ba5-11ea-95ff-37e250f1a890.png">
<img width="522" alt="Screenshot 2020-01-20 at 15 09 11" src="https://user-images.githubusercontent.com/20377428/72739958-02bffa80-3ba5-11ea-8628-fdf0e82ad040.png">
<img width="522" alt="Screenshot 2020-01-20 at 15 57 50" src="https://user-images.githubusercontent.com/20377428/72739959-02bffa80-3ba5-11ea-8cb0-8c2afc5dc38a.png">
