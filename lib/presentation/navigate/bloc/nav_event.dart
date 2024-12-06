abstract class BottomNavEvent {}

class BottomNavItemSelected extends BottomNavEvent {
  final int index;

  BottomNavItemSelected(this.index);
}

class Reset extends BottomNavEvent {}
