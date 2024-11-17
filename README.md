## todo
the whole backend en login
backend still unknown
login need tokens from google. pub domain??

# steps to get this running somewhat
only step 0 and 1 are inportant for windows
## step 0
folow the instruction on how to install on the flutter website for both android and windows desktop: 
```
https://docs.flutter.dev/get-started/install/windows/mobile
```
```
https://docs.flutter.dev/get-started/install/windows/desktop
```
With android studio also install the ndk

Make sure you have jdk 11 installed and in your path

## step 1
with your terminal go to the fioretti_app folder in the project and run the flutter to grab all dependencies
```bash
cd fioretti_app
flutter pub get
```
If all goes right you sould be able to run main.dart in windows debug mode

## step 2 android time!!!
Use java keytool to create a keystore for your project
```
keytool -genkeypair -v -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -keystore release-key.jks -alias your_alias
```

make sure you have the java bin in your path

Create a file named **key.properties** that contains the folowing
```
storePassword=your_password
keyPassword=your_password
keyAlias=your_alias
storeFile=path/to/your/keystore.jks
```
set the password to the passwords you enterd when you used the keytool command
