import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'objects.dart';

///
extension ProviderListenableExtension<T> on ProviderListenable<AsyncValue<T?>> {
  /// this ensures that widgets listening to this are only rebuilt when the data changes
  /// When the data is null the state is returned
  ProviderListenable<AsyncValue<T?>> get buildWhenData {
    return select((value) {
      return switch (AsyncValue.data(value.value).value.isNull) {
        true => value,
        _ => AsyncValue.data(value.value),
      };
    });
  }
}
