import 'IAst.dart';

abstract class IAbstractArrayList<T extends IAst> {
  int size();
  T getElementAt(int i);
  List<T> getList();
  bool add(T elt);
  List<T> getAllChildren();
}
