![DATAStack](https://raw.githubusercontent.com/3lvis/DATAStack/master/Images/datastack-logo.png)

**DATAStack** helps you to alleviate the Core Data boilerplate. Now you can go to your AppDelegate remove all the Core Data related code and replace it with [an instance of DATAStack](https://github.com/3lvis/DATAStack/blob/master/Demo/Demo/AppDelegate/ANDYAppDelegate.m#L19).

## Initialization

You can easily initialize a new instance of **DATAStack** with just your Core Data Model name (xcdatamodel).

**Swift**
``` swift
let dataStack = DATAStack(modelName:"MyAppModel")
```

**Objective-C**
``` objc
DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"MyAppModel"];
```

## Set up

Is recommendable that **DATAStack** gets persisted when this three methods get called in your `AppDelegate`.

**Swift**
```swift
func applicationDidEnterBackground(application: UIApplication) {
    self.dataStack.persistWithCompletion()
}

func applicationWillTerminate(application: UIApplication) {
    self.dataStack.persistWithCompletion()
}
```

**Objective-C**
``` objc
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.dataStack persistWithCompletion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.dataStack persistWithCompletion:nil];
}
```

## Main Thread NSManagedObjectContext

Getting access to the NSManagedObjectContext attached to the main thread is as simple as using the `mainContext` property.

```objc
self.dataStack.mainContext
```

## Background Thread NSManagedObjectContext

You can easily create a new background NSManagedObjectContext for data processing. This block is completely asynchronous and will be run on a background thread.

**Swift**
```swift
func createUser() {
    self.dataStack.performInNewBackgroundContext { backgroundContext in
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: backgroundContext)!
        let object = NSManagedObject(entity: entity, insertIntoManagedObjectContext: backgroundContext)
        object.setValue("Background", forKey: "name")
        object.setValue(NSDate(), forKey: "createdDate")
        try! backgroundContext.save()
    }
}
```

**Objective-C**
```objc
- (void)createUser {
    [self.dataStack performInNewBackgroundContext:^(NSManagedObjectContext *backgroundContext) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:backgroundContext];
        NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:backgroundContext];
        [object setValue:@"Background" forKey:@"name"];
        [object setValue:[NSDate date] forKey:@"createdDate"];
        [backgroundContext save:nil];
    }];
}
```

## Clean up

Deleting the `.sqlite` file and resetting the state of your **DATAStack** is as simple as just calling `drop`.

**Swift**
```swift
self.dataStack.drop()
```

**Objective-C**
```objc
[self.dataStack drop];
```

## Testing

**DATAStack** is optimized for unit testing and it runs synchronously in testing enviroments. Hopefully you'll have to use less XCTestExpectations now.

You can create a stack that uses in memory store like this if your Core Data model is located in your app bundle:

**Swift**
```swift
let dataStack = DATAStack(modelName: "MyAppModel", bundle: NSBundle.mainBundle(), storeType: .InMemory)
```

**Objective-C**
```objc
DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"MyAppModel"
                                                     bundle:[NSBundle mainBundle]
                                                  storeType:DATAStackStoreTypeInMemory];
```

If your Core Data model is located in your test bundle:

**Swift**
```swift
let dataStacks = DATAStack(modelName: "MyAppModel", bundle: NSBundle(forClass: Tests.self), storeType: .InMemory)
```

**Objective-C**
```objc
DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"MyAppModel"
                                                     bundle:[NSBundle bundleForClass:[self class]]
                                                  storeType:DATAStackStoreTypeInMemory];
```

_(Hint: Maybe you haven't found the best way to use NSFetchedResultsController, well [here it is](https://github.com/3lvis/DATASource).)_

## Installation

**DATAStack** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'DATAStack'
```

## Be Awesome

If something looks stupid, please create a friendly and constructive issue, getting your feedback would be awesome.

Have a great day.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)

## License

**DATAStack** is available under the MIT license. See the LICENSE file for more info.
