# Demo application for IDV plugin

## How to build demo application

1. Download or the clone current repository: `git clone https://github.com/regulaforensics/flutter_idv.git`.
2. Put `regula.license` file at `ios/Runner/` and `android/app/src/main/assets/Regula/` (you can get a trial license [here](https://client.regulaforensics.com)).
3. Put `db.dat` file at `ios/Runner/` and `android/app/src/main/assets/Regula/` (you can get a trial database [here](https://client.regulaforensics.com/customer/databases))
4. Run `flutter pub get` within this directory.
5. In `example/lib/main.dart` choose prefered login configuration(`loginType` variable) and provide your login data according to it: username and password for `credentials`, tokenUrl for `token`, apiKey for `apiKey`.
6. Run the app: `flutter run`.
7. After initialization choose **General KYC - AP** from workflows list and click **Start Workflow** button.
8. Complete workflow and get your session id.
