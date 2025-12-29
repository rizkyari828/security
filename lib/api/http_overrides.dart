import 'http_overrides_stub.dart'
    if (dart.library.io) 'http_overrides_io.dart' as impl;

void applySalesHttpOverrides() => impl.applySalesHttpOverrides();

