import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {
  late Size scanArea;
  late double borderRadius;
  InvertedClipper({required this.scanArea, this.borderRadius = 20.0});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: scanArea.width,
              height: scanArea.height),
          Radius.circular(borderRadius - 4)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// ignore: must_be_immutable
class QRScannerOverlay extends StatelessWidget {
  late final Widget clippedWidget;
  final Color? overlayColor;
  late final Size? _scanArea;
  final Color borderColor;
  final double borderRadius;
  final double borderStrokeWidth;

  QRScannerOverlay({
    Key? key,
    String? imagePath,
    this.overlayColor = Colors.black54,
    Size? scanAreaSize,
    double? scanAreaWidth,
    double? scanAreaHeight,
    this.borderColor = Colors.white,
    this.borderRadius = 20,
    this.borderStrokeWidth = 4,
  }) : super(key: key) {
    // Check preconditions for the the scan area
    assert(
      (scanAreaWidth == null && scanAreaHeight == null) ||
          (scanAreaWidth != null && scanAreaHeight != null),
      'You must set both scanAreaWidth and scanAreaHeight!',
    );
    assert(
      (scanAreaSize == null) ||
          ((scanAreaWidth == null) && (scanAreaHeight == null)),
      'You can only set one of scanAreaSize or scanAreaWidth/scanAreaHeight!',
    );

    // If scanAreaSize is set, use it over scanAreaWidth and scanAreaHeight
    if (scanAreaSize != null) {
      _scanArea = scanAreaSize;
    } else if (scanAreaWidth != null && scanAreaHeight != null) {
      _scanArea = Size(scanAreaWidth, scanAreaHeight);
    } else {
      _scanArea = null;
    }

    if (imagePath != null) {
      clippedWidget = Image.asset(
        imagePath,
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(.9),
      );
    } else {
      clippedWidget =
          DecoratedBox(decoration: BoxDecoration(color: overlayColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no scanAreaSize or scanAreaWidth/scanAreaHeight are set, use a default
    final standardScanArea = Size.square(
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 200.0
            : 330.0);
    return Stack(children: [
      ClipPath(
        clipper: InvertedClipper(
          scanArea: _scanArea ?? standardScanArea,
          borderRadius: borderRadius,
        ),
        child: SizedBox.expand(
          child: clippedWidget,
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: CustomPaint(
          foregroundPainter: BorderPainter(
            borderRadius: borderRadius,
            borderColor: borderColor,
            borderStrokeWidth: borderStrokeWidth,
          ),
          child: SizedBox(
            width: (_scanArea?.width ?? standardScanArea.width) + 25.0,
            height: (_scanArea?.height ?? standardScanArea.height) + 25.0,
          ),
        ),
      ),
    ]);
  }
}

// Creates the white borders
class BorderPainter extends CustomPainter {
  final double borderRadius;
  final Color borderColor;
  final double borderStrokeWidth;
  const BorderPainter({
    required this.borderRadius,
    required this.borderColor,
    required this.borderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tRadius = 3 * borderRadius;
    final rect = Rect.fromLTWH(
      borderStrokeWidth,
      borderStrokeWidth,
      size.width - 2 * borderStrokeWidth,
      size.height - 2 * borderStrokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderStrokeWidth,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// class BarReaderSize {
//   static double width = 200;
//   static double height = 200;
// }

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.height - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}
