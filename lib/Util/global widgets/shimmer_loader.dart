// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// class ShimmerLoader extends StatelessWidget {
//   final double? height;
//   final double? width;
//
//   const ShimmerLoader({Key? key, this.height = 120, this.width = 50})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//         period :  const Duration(milliseconds: 1500),
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade200,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(15)),
//           height: height,
//           width: width,
//         ));
//   }
// }
