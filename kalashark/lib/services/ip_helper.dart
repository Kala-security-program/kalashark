import 'dart:io';

Future<String?> getIPv4Address() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
        return addr.address;
      }
    }
  }
  return null;
}

Future<String?> getIPv6Address() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv6 &&
          !addr.isLoopback &&
          !addr.address.startsWith("fe80")) {
        return addr.address;
      }
    }
  }
  return null;
}
