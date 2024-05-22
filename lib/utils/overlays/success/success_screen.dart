// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../src/ui/themes/themes.dart';
// import '../../../src/ui/views/navigation_wrapper/navigation_wrapper.dart';
// import '../../../src/ui/widgets/rich_text/rich_text.dart';
// import '../../extensions/object.dart';
// import '../../extensions/widget.dart';
// import 'success_screen_controller.dart';
//
// /// loading overlay when authentication process is ongoing
// class SuccessScreenOverlay {
//   /// factory constructor authentication loading screen
//   factory SuccessScreenOverlay.instance() => _shared;
//   SuccessScreenOverlay._sharedInstance();
//   static final _shared = SuccessScreenOverlay._sharedInstance();
//   SuccessScreenController? _controller;
//
//   /// opens the loading overlay
//   void show({
//     required BuildContext context,
//     required String header,
//     required List<BaseText> content,
//     String? buttonText,
//     int? jumpToPage,
//   }) {
//     _controller = _showOverlay(
//         context: context, header: header, content: content, buttonText: buttonText, jumpToPage: jumpToPage);
//   }
//
//   /// closes the loading overlay
//   void hide() {
//     _controller?.close();
//     _controller = null;
//   }
//
//   /// overlay view
//   SuccessScreenController? _showOverlay({
//     required BuildContext context,
//     required String header,
//     required List<BaseText> content,
//     String? buttonText,
//     int? jumpToPage,
//   }) {
//     final state = Overlay.of(context);
//     final renderBox = context.findRenderObject() as RenderBox?;
//     if (renderBox != null) {
//       final overlay = OverlayEntry(
//           builder: (_) => SuccessScreen(
//                 header: header,
//                 content: content,
//                 buttonText: buttonText,
//                 onTap: () {
//                   _controller?.close();
//                   _controller = null;
//                 },
//               ));
//       state.insert(overlay);
//       return SuccessScreenController(
//         close: () {
//           overlay.remove();
//           return true;
//         },
//         update: (text) => true,
//       );
//     }
//     return null;
//   }
// }
//
// class SuccessScreen extends StatelessWidget {
//   const SuccessScreen({
//     required this.header,
//     required this.content,
//     this.buttonText,
//     this.jumpToPage,
//     this.onTap,
//     super.key,
//   });
//   final String header;
//   final List<BaseText> content;
//   final String? buttonText;
//   final int? jumpToPage;
//   final VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (reason) {},
//       child: Material(
//         color: Colors.white,
//         shadowColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset('assets/images/success.svg'),
//             Text(header, style: kHeading2),
//             kVerticalSpace4,
//             RichTextWidget(
//               texts: content,
//               styleForAll: kBody2.copyWith(color: kStrongTextColor),
//               customStyle: kBody2.copyWith(fontWeight: FontWeight.w600, color: kPrimaryColor100),
//               textAlign: TextAlign.center,
//             ),
//             kVerticalSpace24,
//             FilledButton(
//               onPressed: () {
//                 onTap?.call();
//                 if (jumpToPage.isNotNull) context.read<PageCubit>().goToPage(jumpToPage!);
//               },
//               child: Text(buttonText ?? 'Continue'),
//             ),
//           ],
//         ).paddingSymmetric(horizontal: 24),
//       ),
//     );
//   }
// }
