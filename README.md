# Zipz SDK for iOS

This open-source library allows you to integrate Zipz into your own iOS app.

<br><br>

## Installation

### Manually

At the moment the only way to install Zipz SDK. Clone or download [framework](https://github.com/Zipz-App/zipz-sdk-ios). 

- Open the new `zipz-sdk-ios-master` folder, and drag the `ZipzSDK.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. 

- Select the `ZipzSDK.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see `ZipzSDK.framework` nested inside a `Products` folder. Select `ZipzSDK.framework`

- And that's it!

  > The `ZipzSDK.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Zipz SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
   Coming soon...
```

### Add Zipz App ID and App Secret

To make the SDK identifiable by Zipz servers, the host app must add `APP_ID` and `APP_SECRET` keys to your project's `Info.plist` file: 

```xml
    <key>APP_ID</key>
    <string>YOUR_APP_ID_STRING</string>
    <key>APP_SECRET</key>
    <string>YOUR_APP_SECRET_STRING</string>
```
By adding those two keys you are now ready to use Zipz SDK framework.

<br><br>

## Authorization

For all interactions between the Host App and Zipz SDK, the user requesting the data must be identified. Zipz provides a `uuid` for each user registered on its database.


### User registration request

To register a new user and get its UUID, host app must send the registration request with all the required parameters. `Parameters` object is just a typealias for dictionary with `[String:Any]` keys and values.


```swift
	ZipzSDK.registerUser(with: parameters) { uuid, error in 

		// Handle response
	}
```

Required `parameters` are passed to `registerUser` request/method as `Parameters` object with keys and values:


| parameter     | requirement  | data type  | description                                                  |
|:--------------|:-------------|:-----------|:-------------------------------------------------------------|
| email         | required     | String     | must be a valid email address and unique in the database     |
| first_name    | required     | String     | must have at least 02 characters                             |
| last_name     | required     | String     | must have at least 02 characters                             |
| gender        | required     | String     | must be one of three options male, female, other             |
| date_of_birth | required     | String     | format yyyy-mm-dd. Only users older than 14 years old        |
| cpf           | required     | Int        | must be a valid cpf number and unique in the database        |
| phone         | optional     | String     | if sent it must be a numeric format                          |


Upon successful new registration the response will contain the code `200`.
When new user registration fails, the response will contain an error. (e.g. code `412` and message "*this email is already in the database*" or code `500` and message "*something went wrong*"). You can access the `User` object by calling: 


```swift
	let user = User.authorizedUser() // Will return nil if user does not exist
```

### Init request

An initial request must happen every time a registered user opens the Host App. The Init request initializes Zipz SDK and establishes a secure connection between the host spp and the Zipz server. No other request can be made without Zipz SDK being initialized and if that happens, the response for all other requests will be **code** `401` **message** `unauthorized`.If method is called for the first time it is recommended to call it in the `registerUser` completion block and pass the `uuid` parameter. To initialize Zipz SDK, call the `initUser` method. 

```swift

	// Method requires user uuid parameter 

	ZipzSDK.initUser(with: uuid) { token, error in 

		// Handle response
	}

```

<br><br>

## Clusters

Clusters are groups of venues defined by parameters to organize screens inside the host app. To access a venue's cluster, the host app must have the permission granted for its `APP_ID`. All venue clusters allowed to the host app and its parameters are available on the **Menu > SDK Settings** inside the Zipz SDK dashboard provided to the client.

### Cluster object

```swift

	// Cluster object public properties

	uuid: String
	type: String
	name: String
	info: String?
	address: String?
	number: String?
	city: City?
	image: Data?
	neighborhood: String?
	latitude: Double
	longitude: Double
	order: Int16
	venues: [Venue]?

```

### List venue clusters request

A list of all venue clusters allowed to the host app containing information about all clusters (`Cluster` object). To get the list call the following method:

```swift

	// Filter your request by passing method parameters such as state, city, type...
	
	let fetch: FetchType = .all // or .update
	let type: ClusterType = .shopping // or .brand, .category, .campaign
	let state = "SP"
	let city =  "São Paulo"

	// All parameters have default values and can be ommited

	ZipzSDK.allClusters(fetch: fetch, type: type, state: state, city: city) { clusters, error in 

		// clusters response object is optional array [Cluster]?
		// Handle response
	}
```

**Error messages:** under development


### Venue cluster details request

A venue cluster details contain information about the cluster itself (`Cluster` object) and also information about all venues (`Venue` object) assigned to that cluster. To check all properties for (`Venue` object), go to the Venues section of the documentation. To get a specific `cluster` detailed information call the following method:


```swift

	// Method requires cluster uuid parameter 

	ZipzSDK.cluster(with: uuid) { cluster, error in

		// cluster response object is optional Cluster?
		// Handle response
	}

```

**Error messages:** <br><br>
Code `404` : "VenueCluster not found" <br>
Code `422` : "Uuid is required"

<br><br>

## Venues

Venues contain offers that are created directly by the merchant. The host app has venues assigned to its `APP_ID`. All venues allowed to the host app and its parameters are available on the **Menu > SDK Settings** inside the Zipz SDK dashboard provided to the client.


### Venue object

```swift

	// Venue object public properties
	
	uuid: String
	name: String
	sufix: String // additional name
	info: String?
	image: Data?
	categories: [String]?
	address: String
	number: String
	neighborhood: String?
	city: City?
	latitude: Double
	longitude: Double

	// venue working hours

	mon: String?
	tue: String?
	wed: String?
	thu: String?
	fri: String?
	sat: String?
	sun: String?
	
```

### List venues request


A list of all venues allowed to the host app containing information about all venues (`Venue` object). To get the full venue list call the following method:


```swift
	
	let fetch: FetchType = .all // or .update

	// fetch parameter has a default value .update can be ommited

	ZipzSDK.allVenues(fetch: fetch) { venues, error in 

		// venues response object is optional array [Venue]?
		// Handle response
	}

	
```

**Error messages:** under development


### Venue details request

A `Venue` object contains all the information about the venue itself and also the information from all offers assigned to that venue. Offers can be **public** or **private** and that is decided by the merchant when creating a coupon. Public Offers are available for all users, and private offers are for a specific audience based on the user behavior. To get a specific `venue` detailed information call the following method:

```swift
	
	// Method requires venue uuid parameter 

	ZipzSDK.venue(with: uuid) { venue, error in

		// venue response object is optional Venue?
		// Handle response
	}
	
```

**Error messages:** <br><br>
Code `422` : "Uuid is required"

<br><br>

## Offers

Offers are coupons created by merchants and assigned to a specific venue. The host app has venues assigned to its `APP_ID`. All venues allowed to the host app and its offers are available on the **Menu > SDK Settings** inside the Zipz SDK dashboard provided to the clients.

### Offer object

```swift

	// Offer object public properties
	
	uuid: String
	name: String
	info: String?
	image: Data?
	categories: [String]?
	status: String
	gender: String
	quantity: String?
	offerPrice: Double
	fullPrice: Double
	expiration: Int16
	
```


### Offer details request

Offer details contain all information about the offer itself and the venue related to it. To get a specific `offer` detailed information call the following method:

```swift
	
	// Method requires offer uuid parameter 

	ZipzSDK.getOffer(with: uuid) { offer, error in

		// offer response object is optional Offer?
		// Handle response
	}


```

**Error messages:** <br><br>
Code `422` : "Uuid is required"

<br><br>

## Transactions

Transactions are created when the user reserves an offer on the Offer Details screen. 
The Transaction starts with the offer reservation and it ends when the user redeems the offers scanning the QR code available at the venue. 


### Reserve offer

Reserve offer request starts a transaction and the `transaction` object will be responded. To reserve an `offer` call the following method:

```swift

	// Method requires offer uuid parameter 

	ZipzSDK.reserveOffer(with: uuid) { offer, error in

		// offer response object is optional Offer?
		// Handle response
	}

```
**Error messages:** <br><br>
Code `422` : "Uuid is required"

<br>

### Redeem offer

Before redeeming an offer one first needs to be reserved. When redeeming scanned QR code string and offer `uuid` are sent as parameters in the following method:

```swift

	// Method requires scanned QR code string 
	// and reserved offer uuid parameter 

	ZipzSDK.redeemOffer(with: qrcode, uuid: uuid) { transaction, error in

		// redeemOffer response object is optional Transaction?
		// Handle response
	}

```

### All transactions

To get all past user transactions call the following method:

```swift

	ZipzSDK.allTransactions() { transactions, error in

		// response object is optional array [Transaction]?
		// Handle response
	}

```

