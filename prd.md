# Bumble Clone Kod İyileştirme Önerileri

## Giriş

Bu belge, Bumble Clone uygulamasının kod tabanının daha temiz, sürdürülebilir ve bakımı daha kolay hale getirilmesi için öneriler içermektedir. Bu öneriler, kodun okunabilirliğini artırmak, test edilebilirliği geliştirmek ve uygulamanın gelecekteki genişletilmesini kolaylaştırmak amacıyla hazırlanmıştır.

## İyileştirme Önerileri

### 1. Tutarlı Bağımlılık Enjeksiyonu

**Mevcut Durum:** Servisler doğrudan BLoC'lar ve repository'ler içinde oluşturuluyor. Bu durum, sıkı bağlantılar oluşturarak test edilebilirliği zorlaştırıyor.

```dart
// AuthBloc içindeki mevcut yaklaşım
final AuthRepository _authRepository = AuthRepository();
final IUserRepository _userRepository = IUserRepository();

// SwipeScreen içindeki mevcut yaklaşım
final UserService _userService = UserService();
final PreferencesService _preferenceService = PreferencesService();
final SwipeService _swipeService = SwipeService();
```

**Öneri:** `get_it` veya `injectable` gibi paketleri kullanarak uygun bir bağımlılık enjeksiyon sistemi uygulayın. Bu, kodunuzu daha test edilebilir ve sürdürülebilir hale getirecektir.

```dart
// get_it ile örnek
// service_locator.dart dosyasında
final getIt = GetIt.instance;

void setupLocator() {
  // Servisleri kaydet
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<UserService>(() => UserService());

  // Repository'leri kaydet
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<AuthService>()));

  // BLoC'ları kaydet
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}

// Daha sonra BLoC'unuzda
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    // ...
  }
}
```

### 2. Hata Yönetiminin İyileştirilmesi

**Mevcut Durum:** Kod tabanındaki hata yönetimi temel seviyede, çoğu metot sadece istisnaları yeniden fırlatıyor veya genel hata mesajları gösteriyor.

**Öneri:** Özel istisnalar ve anlamlı hata mesajları içeren özel bir hata yönetim sistemi oluşturun.

```dart
// Özel istisnalar oluşturun
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException(this.message, this.code);

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

// Servislerinizde bu istisnaları kullanın
Future<UserModel> signUp(String email, String password) async {
  try {
    // Uygulama
  } catch (e) {
    if (e is PostgrestException) {
      throw AuthException('Kayıt sırasında veritabanı hatası', e.code);
    } else if (e is AuthException) {
      rethrow;
    } else {
      throw AuthException('Kayıt sırasında bilinmeyen hata', 'unknown');
    }
  }
}
```

### 3. Yorum Satırındaki Kodları Temizleme

**Mevcut Durum:** Dosyalarda, kodun okunmasını zorlaştıran çok sayıda yorum satırı haline getirilmiş kod parçası var.

**Öneri:** Tüm yorum satırındaki kodları kaldırın. Eski uygulamaları referans almanız gerekirse, bunun yerine sürüm kontrolünü kullanın.

Örneğin, `swipe_screen.dart` içinde:

```dart
// Şu tür yorum satırındaki importları kaldırın:
// / import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import '../../../common/components/swipe_card.dart';

// Ve yorum satırındaki widget'ları kaldırın:
// Center(
//     child: CardSwiper(
//   maxAngle: 180,
//   cardBuilder: (context, index, horizontalOffsetPercentage,
//           verticalOffsetPercentage) =>
//       const SwipeCard(image: "https://picsum.photos/200/300"),
//   cardsCount: 3,
// )),
```

### 4. Tutarlı İsimlendirme Kuralları

**Mevcut Durum:** Kod tabanı genelinde isimlendirme konusunda tutarsızlıklar var.

**Öneri:** Tutarlı isimlendirme kuralları benimseyin:

- Dosya adları için `snake_case` kullanın
- Değişkenler ve metodlar için `camelCase` kullanın
- Sınıflar ve enum'lar için `PascalCase` kullanın

### 5. Sabitleri Çıkarma

**Mevcut Durum:** UI bileşenlerinde sabit değerlere dönüştürülmesi gereken yazılı değerler var.

**Öneri:** Tüm sabit değerleri (boyutlar, süreler vb.) bir sabitler dosyasına taşıyın.

```dart
// constants.dart içinde
class UIConstants {
  static const double appBarHeight = 64.0;
  static const double cardBorderRadius = 16.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
```

### 6. Uygun Durum Yönetimi Uygulaması

**Mevcut Durum:** Kod tabanı durum yönetimi için BLoC kullanıyor, ancak bazı durumlarda durum doğrudan widget'larda yönetiliyor.

**Öneri:** Durum yönetiminde tutarlı olun. Tüm durum yönetimi mantığını BLoC'lara veya diğer durum yönetimi çözümlerine taşıyın.

### 7. Dokümantasyon Ekleme

**Mevcut Durum:** Kod, yeni geliştiricilerin anlamasını zorlaştıran uygun dokümantasyondan yoksun.

**Öneri:** Tüm genel sınıflara, metodlara ve özelliklere dokümantasyon ekleyin.

```dart
/// E-posta ve şifre ile bir kullanıcıyı doğrular
///
/// Kullanıcı bilgilerini içeren bir [AuthResponse] döndürür
/// Doğrulama başarısız olursa [AuthException] fırlatır
Future<AuthResponse> signIn(String email, String password) async {
  // Uygulama
}
```

### 8. Birim Testleri Uygulama

**Mevcut Durum:** Sağlam bir test stratejisi yok gibi görünüyor.

**Öneri:** Kod kalitesini sağlamak ve regresyonları önlemek için tüm repository'ler, servisler ve BLoC'lar için birim testleri ekleyin.

### 9. İş Mantığını UI'dan Ayırma

**Mevcut Durum:** Bazı UI bileşenleri, BLoC'lara veya servislere taşınması gereken iş mantığı içeriyor.

**Öneri:** İlgi alanlarının temiz bir şekilde ayrılmasını sağlamak için tüm iş mantığını UI bileşenlerinden çıkarın.

### 10. Ortam Değişkenlerini Doğru Kullanma

**Mevcut Durum:** Ortam değişkenlerine mevcut yaklaşım iyileştirilebilir.

**Öneri:** Geliştirme, hazırlık ve üretim için farklı yapılandırmalara sahip uygun bir ortam yapılandırma sistemi kullanın.

### 11. Import'ları Optimize Etme

**Mevcut Durum:** Bazı dosyalarda kullanılmayan import'lar var.

**Öneri:** Tüm dosyalardaki import'ları temizleyerek yalnızca gerekli olanları dahil edin.

## Sonuç

Bu önerileri uygulayarak, kod tabanınız daha sürdürülebilir, test edilebilir ve projeye katılan yeni geliştiriciler için daha anlaşılır hale gelecektir. Bu değişiklikler, uzun vadede geliştirme sürecini hızlandıracak ve hata ayıklama süresini azaltacaktır.

## Uygulama Planı

1. Bağımlılık enjeksiyon sistemini uygulayın
2. Hata yönetimi stratejisini iyileştirin
3. Kodları temizleyin (yorum satırındaki kodlar, kullanılmayan importlar vb.)
4. Tutarlı isimlendirme kuralları uygulayın
5. Sabitleri çıkarın
6. Durum yönetimini iyileştirin
7. Dokümantasyon ekleyin
8. Test stratejisi geliştirin
