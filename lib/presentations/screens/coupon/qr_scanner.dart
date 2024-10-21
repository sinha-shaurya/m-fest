import 'package:aash_india/bloc/singleCoupon/single_coupon_bloc.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final String couponId;
  const QRScannerScreen({required this.couponId, super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return BlocListener<SingleCouponBloc, SingleCouponState>(
      listener: (context, state) {
        if (state is ScanSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
          ));
        }
        if (state is SingleCouponFailed) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppColors.errorColor,
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR Code'),
        ),
        body: BlocBuilder<SingleCouponBloc, SingleCouponState>(
          builder: (context, state) {
            if (state is SingleCouponLoading) {
              return const CircularProgressIndicator(
                color: AppColors.primaryColor,
              );
            }
            return MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (barcodes) {
                List<Barcode> bars = barcodes.barcodes;
                for (final barcode in bars) {
                  if (barcode.rawValue != null) {
                    BlocProvider.of<SingleCouponBloc>(context).add(
                        CouponScanEvent(widget.couponId, barcode.rawValue));
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
