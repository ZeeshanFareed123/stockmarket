enum TransportSecurityMode { systemTrust, certificatePinning }

final class TransportSecurityPolicy {
  const TransportSecurityPolicy({
    this.mode = TransportSecurityMode.systemTrust,
    this.allowedCertificateFingerprints = const [],
  });

  final TransportSecurityMode mode;
  final List<String> allowedCertificateFingerprints;
}
