import 'IAst.dart';

abstract class IAstVisitor {
  bool preVisit(IAst element);
  void postVisit(IAst element);
}
