class Constants{
  static String? email;
  static String? photoUrl;
  static String? uid;
  static String? username;
  static String? name;
}
// FirebaseFirestore.instance.collection('noteapp').doc('${Listfile.email}').collection('notes').add({
// 'userName': Constants.email,
// 'uid': Constants.uid,
// 'message': chattxt.text,
// 'time': DateTime.now().toString(),
// });