# Fog
Whether you need compute, dns, storage, or a multitude of other services, fog provides an accessible entry point and facilitates cross service compatibility. Fog delivers the knowledge of cloud experts to you, helping you to bootstrap your cloud usage and guiding you as your own expertise develops.
 
By coding with fog from the start you avoid vendor lock-in and give yourself more flexibility to provide value. Whether you are writing a library, designing a software as a service product or just hacking on the weekend this flexibility is a huge boon.

# Structure
fog is the Ruby cloud computing library, top to bottom:

- Collections provide a simplified interface, making clouds easier to work with and switch between.
- Requests allow power users to get the most out of the features of each individual cloud.
- Mocks make testing and integrating a breeze.

#### Collections
Some collections are available across multiple providers:
- dns providers have `zones` and `records`
- compute providers have `images` and `servers`

Collections share basic CRUD type operations, such as: 
- **all** - fetch every object of that type from the provider.
- **get** - fetch a single object by it’s identity from the provider.

#### Models
Many of the collection methods return individual objects, which also provide common methods:
- **destroy** - will destroy the persisted object from the provider.
- **save** - persist the object to the provider.

#### Requests
Requests allow you to dive deeper when the models just can’t cut it. You can see a list of available requests by calling `requests` on the connection object.

#### Mocks
As you might imagine, testing code using fog can be slow and expensive, constantly turning on and shutting down instances. Mocking allows skipping this overhead by providing an in-memory representation resources as you make requests.

# Fog Provider Directory Structure
```sh
Plugin Root
      |--- lib
            |--- fog
                 |--- azurerm.rb #registers provider
                 |--- azurerm
                       |--- compute.rb #registers all models, collections and requests
                       |--- dns.rb #registers all models, collections and requests
                       |--- storage.rb #registers all models, collections and requests
                       |--- models #models and collections
                       	     |--- compute #models and collections for compute
                             |--- dns
                             |--- storage
                       |--- requests #requests - includes Real and Mock Classes
                       	     |--- compute #requests for compute
                             |--- dns
                             |--- storage
```

For more information about fog structure [Click Here](http://fog.io/about/structure.html)
