import 'package:flutter_bloc/flutter_bloc.dart';

import 'nav_event.dart';
import 'nav_state.dart';

/// Alt navigasyon çubuğu işlemlerini yöneten BLoC sınıfı.
///
/// Bu sınıf, alt navigasyon çubuğundaki sekmelerin seçilmesi ve sıfırlanması gibi
/// navigasyon işlemlerini yönetir.
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  /// BottomNavBloc sınıfının constructor'ı.
  BottomNavBloc() : super(BottomNavInitial(1)) {
    /// Alt navigasyon çubuğundaki bir sekme seçildiğinde tetiklenir.
    ///
    /// [event.index] parametresi, seçilen sekmenin indeksini alır.
    on<BottomNavItemSelected>((event, emit) {
      emit(BottomNavInitial(event.index));
    });

    /// Alt navigasyon çubuğunu sıfırlar.
    ///
    /// Varsayılan sekmeyi (indeks 1) seçer.
    on<Reset>(
      (event, emit) => emit(BottomNavInitial(1)),
    );
  }
}
