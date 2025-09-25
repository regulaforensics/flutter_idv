# Regula IDV plugin for Flutter
<?code-excerpt path-base="example/lib"?>

[![pub package](https://img.shields.io/pub/v/flutter_idv.svg)](https://pub.dev/packages/flutter_idv)

IDV is a framework that unifies access to all Regula products.

## Android Integration

In order to use this plugin, in `android/app/build.gradle` add `kotlin-kapt` plugin and enable `dataBinding`:
```
plugins {
    id "kotlin-kapt"
}

android {
    buildFeatures {
        dataBinding true
    }
}
```

## Documentation
* [Documentation](https://docs.regulaforensics.com/develop/idv-sdk/mobile)
* [API Reference](https://pub.dev/documentation/flutter_idv)

## Support
If you have any technical questions, feel free to [contact](mailto:support@regulaforensics.com) us or create issues [here](https://github.com/regulaforensics/flutter_idv/issues).
