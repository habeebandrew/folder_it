// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:internet_applications/BusinessLogic/Reports%20Bloc/reports_bloc.dart';
// import 'package:internet_applications/Data/process_model.dart';
// import 'package:internet_applications/Util/global%20widgets/custom_text_field.dart';
// import 'package:internet_applications/Util/global%20widgets/elevated_button_widget.dart';
// import 'package:internet_applications/Util/requests_params.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// import '../../BusinessLogic/Groups Bloc/groups_bloc.dart';
// import '../../Data/groups_model.dart';
// import '../../Util/constants.dart';
//
// CardDataSource _cardDataSource = CardDataSource(cardElements: []);
//
// class ReportsScreen extends StatefulWidget {
//   ReportsScreen({super.key});
//
//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }
//
// class _ReportsScreenState extends State<ReportsScreen> {
//   Timer? searchOnStoppedTyping;
//
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController fileTitleController = TextEditingController();
//   TextEditingController updatedController = TextEditingController();
//   TextEditingController groupNameController = TextEditingController();
//   TextEditingController fileStatusController = TextEditingController();
//   TextEditingController reservedController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ReportsBloc, ReportsState>(
//       listener: (context, state) {
//         if (state is ReportsLoaded) {
//           _cardDataSource = CardDataSource(cardElements: state.processes);
//         }
//       },
//       builder: (context, state) {
//         return SizedBox(
//           width: getWidth(context),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: 250,
//                 width: double.infinity,
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "You Can Filter The Report Here",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontFamily: kSemiBoldFont,
//                         color: kPrimaryBlueColor,
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               height: 50,
//                               child: CustomTextField(
//                                 fontSize: 9,
//                                 controller2: userNameController,
//                                 passwordBool: false,
//                                 hintText: "user name",
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               child: CustomTextField(
//                                 fontSize: 9,
//                                 controller2: fileTitleController,
//                                 passwordBool: false,
//                                 hintText: "file title",
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               child: CustomTextField(
//                                 maxLength: 1,
//                                 inputFormats: [
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp('[01]')), // Only allow '0' and '1'
//                                 ],
//                                 fontSize: 9,
//                                 controller2: updatedController,
//                                 passwordBool: false,
//                                 hintText: "updated (0 or 1)",
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               child: CustomTextField(
//                                 fontSize: 9,
//                                 controller2: groupNameController,
//                                 passwordBool: false,
//                                 hintText: "group name",
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               child: CustomTextField(
//                                 maxLength: 1,
//                                 inputFormats: [
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp('[01]')), // Only allow '0' and '1'
//                                 ],
//                                 fontSize: 9,
//                                 controller2: fileStatusController,
//                                 passwordBool: false,
//                                 hintText: "file status (0 or 1)",
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             SizedBox(
//                               width: getWidth(context) * .2,
//                               child: CustomTextField(
//                                 maxLength: 1,
//                                 inputFormats: [
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp('[01]')), // Only allow '0' and '1'
//                                 ],
//                                 fontSize: 9,
//                                 controller2: reservedController,
//                                 passwordBool: false,
//                                 hintText: "file reserved (0 or 1)",
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       width: 150,
//                       child: ElevatedButtonWidget(
//                         title: 'Filter',
//                         onPressed: () {
//                           RequestParams requestParams = RequestParams(
//                               groupName: groupNameController.text,
//                               fileStatus: fileStatusController.text,
//                               fileReserved: reservedController.text,
//                               updated: updatedController.text,
//                               userName: userNameController.text,
//                               fileTitle: fileTitleController.text);
//                           context.read<ReportsBloc>().add(
//                               GetReportEvent(requestParams: requestParams));
//                         },
//                         fontFamily: kNormalFont,
//                         color: kPrimaryBlueColor,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               if (state is! ReportsLoaded)
//                 const Expanded(
//                   child: Center(
//                       child: CircularProgressIndicator(
//                     color: kPrimaryBlueColor,
//                   )),
//                 ),
//               if (state is ReportsLoaded)
//                 Expanded(
//                   child: SfDataGrid(
//                     shrinkWrapRows: true,
//                     shrinkWrapColumns: true,
//                     source: _cardDataSource,
//                     columnWidthMode: ColumnWidthMode.none,
//                     columns: <GridColumn>[
//                       GridColumn(
//                         width: getWidth(context) * .1,
//                         columnName: 'File Title',
//                         label: Container(
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'File Title',
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   fontFamily: kSemiBoldFont,
//                                   color: kPrimaryBlueColor),
//                             )),
//                       ),
//                       GridColumn(
//                         width: getWidth(context) * .1,
//                         columnName: 'User Name',
//                         label: Container(
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'User Name',
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   fontFamily: kSemiBoldFont,
//                                   color: kPrimaryBlueColor),
//                             )),
//                       ),
//                       GridColumn(
//                           width: getWidth(context) * .15,
//                           columnName: 'Proceed At',
//                           label: Container(
//                             alignment: Alignment.center,
//                             child: const Text('Proceed At',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: kSemiBoldFont,
//                                     color: kPrimaryBlueColor)),
//                           )),
//                       GridColumn(
//                           width: getWidth(context) * .15,
//                           columnName: 'Updated At',
//                           label: Container(
//                             alignment: Alignment.center,
//                             child: const Text('Updated At',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: kSemiBoldFont,
//                                     color: kPrimaryBlueColor)),
//                           )),
//                       GridColumn(
//                           width: getWidth(context) * .1,
//                           columnName: 'Reserved',
//                           label: Container(
//                             alignment: Alignment.center,
//                             child: const Text('Reserved ',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: kSemiBoldFont,
//                                     color: kPrimaryBlueColor)),
//                           )),
//                       GridColumn(
//                           width: getWidth(context) * .1,
//                           columnName: 'Updated',
//                           label: Container(
//                             alignment: Alignment.center,
//                             child: const Text('Updated ',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: kSemiBoldFont,
//                                     color: kPrimaryBlueColor)),
//                           )),
//                       GridColumn(
//                           width: getWidth(context) * .1,
//                           columnName: 'File Status',
//                           label: Container(
//                             alignment: Alignment.center,
//                             child: const Text('File Status ',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: kSemiBoldFont,
//                                     color: kPrimaryBlueColor)),
//                           )),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class CardDataSource extends DataGridSource {
//   CardDataSource({required List<ProcessModel> cardElements}) {
//     dataGridRows = cardElements
//         .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
//               DataGridCell<String>(
//                   columnName: 'File Title', value: dataGridRow.file!.title),
//               DataGridCell<String>(
//                   columnName: 'User Name', value: dataGridRow.user!.name),
//               DataGridCell<String>(
//                   columnName: 'Proceed At',
//                   value: dataGridRow.createdAt.toString()),
//               DataGridCell<String>(
//                   columnName: 'Updated At',
//                   value: dataGridRow.updatedAt.toString()),
//               DataGridCell<Widget>(
//                   columnName: 'Reserved',
//                   value: dataGridRow.reserved == 0
//                       ? const Icon(
//                           Icons.close,
//                           color: Colors.red,
//                         )
//                       : const Icon(
//                           Icons.check,
//                           color: Colors.green,
//                         )),
//               DataGridCell<Widget>(
//                   columnName: 'Updated',
//                   value: dataGridRow.updated == 0
//                       ? const Icon(
//                           Icons.close,
//                           color: Colors.red,
//                         )
//                       : const Icon(
//                           Icons.check,
//                           color: Colors.green,
//                         )),
//               DataGridCell<Widget>(
//                   columnName: 'File Status',
//                   value: dataGridRow.file!.status == 0
//                       ? const Icon(
//                           Icons.close,
//                           color: Colors.red,
//                         )
//                       : const Icon(
//                           Icons.check,
//                           color: Colors.green,
//                         )),
//             ]))
//         .toList();
//   }
//
//   List<DataGridRow> dataGridRows = [];
//
//   @override
//   List<DataGridRow> get rows => dataGridRows;
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//       return Container(
//         alignment: Alignment.center,
//         child: dataGridCell.value is String
//             ? Text(
//                 dataGridCell.value.toString(),
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontFamily: kNormalFont, fontSize: 10),
//               )
//             : dataGridCell.value,
//       );
//     }).toList());
//   }
// }
