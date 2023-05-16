<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A simple QR Scanner style overlay to be used with a stack ( and a camera scanner )

## Features

The Widget provides a qr code scanner style overlay to be used with a stack , qr scanning widget

It has 2 modes
one where you can pass in an image path ( only supports images as assets ) as its overlay
another where you can pass in a color as overlay

![image](https://github.com/Govind-S-B/qr_scanner_overlay/assets/62943847/911c276e-1588-46a8-88e7-85c18e958a7a)


## Getting started

just import the package and use QRScannerOverlay

## Usage

```
return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraConroller,
            onDetect: (capture) {
                // do something
          },),
          QRScannerOverlay(imagePath: "images/test.jpg",)
        ],
      ),
    );
```

```
QRScannerOverlay(color: Colors.black.withOpacity(0.5),)
```

## Additional information

Try tinkering around with the package if you want something specific , you can always check up on the github repo for issues or other help
Special thanks to [Fluttify](https://gist.github.com/r-yeates/0bad6b8a07e01520a1b3ceba32bad77d) for the baseline overlay
