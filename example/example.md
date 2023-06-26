
## Importing the package

```
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
```

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
QRScannerOverlay(overlayColor: Colors.black.withOpacity(0.5),)
```

### Additional Parameters
scanAreaSize or scanAreaWidth/scanAreaHeight  
borderColor  
borderRadius  
borderStrokeWidth  

```
//Example QrScanner
QrScannerOverlay(scanWidth: 300, scanHeight: 300, borderColor: Colors.red);
```
