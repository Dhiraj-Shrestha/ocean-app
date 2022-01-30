import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ocean_publication/bloc/cart_provider.dart';
import 'package:ocean_publication/models/products/api_data.dart';
import 'package:rxdart/subjects.dart';

class CartListBloc extends BlocBase {
  CartListBloc();

  final _listController = BehaviorSubject<List<LibraryItems>>.seeded([]);

  CartProvider provider = CartProvider();

  String email;

 

  addUserEmail(String userEmail) {
    email = userEmail;
  }



  //  output
  Stream<List<LibraryItems>> get listStream => _listController.stream;

  // input
  Sink<List<LibraryItems>> get listSink => _listController.sink;

  // business Logic
  addToList(LibraryItems item) {
    listSink.add(provider.addToList(item));
  }

  removeFromList(LibraryItems item) {
    listSink.add(provider.removeFromList(item));
  }

  removeAllCartData() {
    listSink.add(provider.clearCart());
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
