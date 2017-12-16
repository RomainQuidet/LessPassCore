# LessPassCore
LessPass core framework for iOS

## Origin
This framework is a port of the LessPass original framework in js : [LessPass](https://lesspass.com)

## License
Released under the GPL v3 license

## Integration
This framework requires iOS 9.0+

It is compatible with ObjC and Swift.

**With cocoapods:**

Add this to your podfile
```
pod 'LessPassCore', '~> 1.0'
```

**With Carthage:**

Add this to your cartfile
```
github "RomainQuidet/LessPassCore" ~> 1.0
```

## Usage

**ObjC**

```ObjC
#import <LessPassCore/LessPassCore.h>

// Create a profile
LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];

// Configure it as user wants
profile.options.symbols = NO;
profile.options.lowercase = NO;
profile.options.uppercase = NO;
profile.options.length = 6;
profile.options.counter = 3;

// Generate the password from the master password given by the user
NSString *masterPassword = @"password";
NSString *generatedPassword = [LPCore generatePasswordWithProfile:profile andMasterPassword:masterPassword];
```

**Swift**

```swift
import LessPassCore

// Create a profile
let profile = LPProfile(site: "example.org", andLogin: "contact@example.org")

// Configure it as user wants
profile.options.symbols = false
profile.options.lowercase = false
profile.options.uppercase = false
profile.options.length = 6
profile.options.counter = 3

// Generate the password from the master password given by the user
let generatedPassword = LPCore.generatePassword(with: profile, andMasterPassword: "password")
```
