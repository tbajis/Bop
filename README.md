# Bop for iOS

This repository contains the source code for **Bop**, an iOS application written in Swift built with [Fabric](https://get.fabric.io) and [Foursquare](https://foursquare.com).

**Bop** is a fun way to search [Foursquare](https://foursquare.com) venues with a particular interest theme. Start by choosing from interest categories including "Sports", "Music", "Food", "Art", "Fashion" and "Culture." Browse [Twitter](https://twitter.com) updates and photos for specific venues in a detail view.

## Fabric

**Bop** uses many of the features available in [Fabric](https://get.fabric.io), including Crashlytics, Answers, Sign In with Twitter and Phone Number via Digits, and embedded Timelines with the TwitterKit.

## Foursquare

**Bop** uses the [Fousquare API](https://developer.foursquare.com/) to search for venues using an interest keyword and geographic location. Photos are downloaded using venues unique "ID" parameter from [Foursquare](https://foursquare.com).  

## Compatibiity

This project is written in **Swift 3**. Please have the **latest version** of Xcode (version 8) installed prior to running. **Bop** is compatible with iOS 8+

## Getting Started

To get started and run the app, you need to follow these steps:  
1. Fork the [official repository](https://github.com/tbajis/Bop).
2. Open the **Bop** project in Xcode
3. Sign up/Register for Fabric on [fabric.io](https://get.fabric.io) and [Foursquare](https://foursquare.com/developers/register).
4. Download and install the Fabric Mac App.
5. Sign in with your Fabric account, select the **Bop** Xcode project and choose organization.
6. Install Crashlytics, Digits, and Twitter Kits from the Mac app.
7. Run **Bop** on your iPhone or the iOS Simulator.

### Acquire a Foursquare Client ID and Secret Key

When you [register with Foursquare](https://foursquare.com/developers/register) be sure to secure a Client ID and Secret Key.

When you've secured Client ID and Secret Key, perform the following instructions: 

* Open the **Bop** project file in Xcode
* In the project navigator, find the **FoursquareConstants.swift** file
* Enter your Foursquare Client ID and Secret in the appropriate fields:

```
static let ClientId = "YOUR CLIENT ID HERE"
static let ClientSecret = YOUR CLIENT SECRET HERE"

```

## Usage

This app has three view controller scenes
1. **Login View**
2. **Map and Table View**
3. **Detail View**

## Contributing

I'd love to get pull requests from everyone. Here are some ways _you_ can contribute:

* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code(ie. fix typos, add comments, clean up inconsistent white space)
* by creating more detailed, eye-pleasing design elements

### Submitting a Pull Request

1. [Fork](https://help.github.com/articles/fork-a-repo/) the [official repository.](https://github.com/tbajis/Bop)
2. [Create a topic branch.](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/)
3. Implement your feature or bug fix.
4. Add, commit, and push your changes. Please try to use the [Udacity Git Commit Message Style Guide.](http://udacity.github.io/git-styleguide/)
5. [Submit a pull request.](https://help.github.com/articles/about-pull-requests/)

## Notes

* Please add tests if you change the code.
* If you don't know how to add a test, please put in a PR and leave a comment asking for help. I'd love to help!

## License

Copyright 2017 Thomas Bajis.  

Licensed under the [Apache License, Version 2.0:](http://www.apache.org/licenses/LICENSE-2.0).

## Issues

