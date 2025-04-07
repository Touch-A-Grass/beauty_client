# beauty_client

Beauty Client for Beauty Service

## Building Production

Android Store
```flutter build aab --release --dart-define-from-file=configs/production.json --no-tree-shake-icons```

Android Internal
```flutter build apk --release --dart-define-from-file=configs/production.json --no-tree-shake-icons```

Web
```flutter build web --release --dart-define-from-file=configs/production.json --no-tree-shake-icons```


## Building Develop

Android Store
```flutter build aab --release --dart-define-from-file=configs/develop.json --no-tree-shake-icons```

Android Internal
```flutter build apk --release --dart-define-from-file=configs/develop.json --no-tree-shake-icons```

Web
```flutter build web --release --dart-define-from-file=configs/develop.json --no-tree-shake-icons```