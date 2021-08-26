import 'IAst.dart';
import 'Util.dart';

abstract class IAbstractArrayList<T extends IAst> {
  int size();
  T getElementAt(int i);
  ArrayList getList();
  bool add(T elt);
  ArrayList getAllChildren();
}
