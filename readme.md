# Social Network tool [0.0.1]


This application is created in order to make life much simpler and to help people share with there photos in different social networks in couple of taps in their smartphones.
###### Specific feature of this application - multi language support. It can help make posts in different social medias on accounts with different languages simultaneously

#### This application solves such problems as:
+ posting one post to custom social networks and multiple accounts
+ change description of the post depending on: 
	 * Social Network 
	 * Account
	 * Account language
+ **[In future]** scheduling posts 
+ **[In future]** auto liking/subscribing/unsubscribing  system 
#### Supported Social Networks
1. Instagram
2. **[In future]** Twitter
3. **[In future]** Facebook

## Examples of work
#### Logging in

![Alt Text](https://media.giphy.com/media/kEjDHIF3CjMfk3d4I9/giphy.gif)

#### Creating a post
![Alt Text](https://media.giphy.com/media/chnxYVfYgkj7WmnqFP/giphy.gif)

## Additional information

This application requires backend part which must be working alongside with the android app, as it uses at least *[instagram_private_api](https://github.com/ping/instagram_private_api)* based on python.

#### Android part consists of:
* **main.dart** - run application, all routes written here
* **accountData.dart**, **postData.dart** - files which are responsible for conversation with server
* **dataController.dart** - responsible for View and Data collaboration, saving data to local memory
* **globalVals.dart** - global values written here
* **customWidget...dart** - files with custom created widgets
* ***other files*** - View
---
in *globalVals.dart* you can change URL value in order application to send requests to the proper address
#### Backend part:
Actually this part makes magic (*at least for Instagram*), this part makes authorization and then posting from your account. Backend part has nothing complicated, it is written in python Flask and most actions is basic usage of *[instagram_private_api](https://github.com/ping/instagram_private_api)*

## Legal
Disclaimer: This is not affiliated, endorsed or certified by Instagram. This is an independent and unofficial application. Strictly not for spam. Use at your own risk. 
