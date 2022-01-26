import 'package:ocean_publication/models/products/api_data.dart';

class CartProvider {
  List<LibraryItems> items = [];

  bool isPresent;

  List<LibraryItems> addToList(LibraryItems item) {
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].id == item.id) {
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        items.add(item);
      }
    } else {
      items.add(item);
    }

    return items;
  }

  clearCart() {
    items.clear();
  }

  void increaseItemQuantity(LibraryItems item) => item.incrementQty();
  void decreaseItemQuantity(LibraryItems item) => item.decrementQty();

  List<LibraryItems> removeFromList(LibraryItems item) {
    if (item.quantity > 1) {
      //only decrease the quantity
      decreaseItemQuantity(item);
    } else {
      //remove it from the list
      items.remove(item);
    }
    return items;
  }
}
