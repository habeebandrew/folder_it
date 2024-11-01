// enum ServicesResponseStatues {
//   success,
//   networkError,
//   modelError,
//   someThingWrong,
//   wrongData,
//   unauthorized,
// }
// enum PageType{
//   privacyPolicy,
//   usagePolicy,
//   aboutUs
// }
// enum HomeRequestType { sections, invoices, analysis }
//
// final serviceValues = EnumValues({
//   "Sent Successfully": ServicesResponseStatues.success,
//   "Connection error !": ServicesResponseStatues.networkError,
//   "Something went wrong !": ServicesResponseStatues.someThingWrong,
//   "Failed to parse model !": ServicesResponseStatues.modelError,
//   "Data sent is not correct !": ServicesResponseStatues.wrongData
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
