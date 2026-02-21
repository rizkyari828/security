# SALES

fvm flutter run --dart-define=FACE_TUNING_PROFILE=strict --dart-define=FACE_DEBUG_TELEMETRY=true

fvm flutter run \
  --dart-define=FACE_MIN_SIMILARITY=0.80 \
  --dart-define=FACE_VERIFICATION_FRAMES=4 \
  --dart-define=FACE_MIN_VERIFICATION_SAMPLES=3 \
  --dart-define=FACE_MIN_VERIFICATION_MATCHES=2 \
  --dart-define=FACE_MIN_SHARPNESS=0.025 \
  --dart-define=FACE_MIN_BRIGHTNESS=0.22 \
  --dart-define=FACE_MAX_BRIGHTNESS=0.88 \
  --dart-define=ATTENDANCE_RADIUS_METERS=150 \
  --dart-define=FACE_DEBUG_TELEMETRY=true


Development and design by RIZKY ARI PRATAMA
