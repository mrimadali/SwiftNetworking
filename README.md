# SwiftNetworking
A lightweight, highly customizable network layer built using the latest Swift updates. This framework provides a generic, reusable solution for handling network requests and responses, making it easier to interact with APIs in a clean and type-safe manner. It leverages Swift's powerful generics and modern concurrency features like async/await to streamline network communication in your iOS apps.

Key Features:


**Generic Network Requests:** Simplified API interaction with type-safe, generic methods.<br>
**Async/Await Support:** Modern Swift concurrency for cleaner, more readable code.<br>
**Error Handling:** Comprehensive error handling and custom error types.<br>
**Customizable:** Easily extendable to fit your specific networking needs.<br>
<br>
Ideal for developers looking to build scalable and maintainable iOS applications with a robust networking foundation.

**Integration:**
You can use The Swift Package Manager to install **SwiftNetworking** to your packages: https://github.com/mrimadali/SwiftNetworking

**Output using lib:**
https://github.com/user-attachments/assets/0b2ec0c8-2dcc-43db-8625-aa722462b5bd


Usage: 

1. Create a file for Endpoint as such **ProductEndpoint**
2. Create an Enum and Extension conforming to **APIConfiguration**
3. Create properties for _baseURLString, urlPath, parameters, method, API headers & API body_ as given:

   ```import SwiftNetworking

      enum ProductEndpoint {
       case getProducts
      }


   extension ProductEndpoint: APIConfiguration {
    var baseURLString: String {
        return "https://fakestoreapi.com"
    }

    var urlPath: String {
        let path: String
        switch self {
        case .getProducts:
            path =  "/products"
        }
        return baseURLString + path
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
    
    var method: APIMethod {
        let method: APIMethod
        switch self {
        case .getProducts:
            method = .get
        }
        return method
    }

    var headers: [String: String]? {

        var keyValPair = [
            "Content-type": "application/json",
            "accept": "application/json",
        ]
        
        switch self {
       /* case let .login:
            keyValPair["Authorization"] = "Bearer \(authToken)"*/
        default:
            break
        }

        return keyValPair
    }

    var body: Encodable? {
        switch self {
       /* case let .login(model):
            return model*/
        default:
            return nil
        }
    }
   }```

4. Create a repository for a **ProductEndPoint**, let it be **ProductRepository**:

   
```import SwiftNetworking

   protocol ProductProtocol {
    func fetchProducts() async -> Result<ProductRoot, APIError>
   }

   class ProductRepository: ProductProtocol {
    static let shared = ProductRepository()
    
    let manager: NetworkManager
    
    init(manager: NetworkManager = NetworkManager.shared) {
        self.manager = manager
    }
    
    func fetchProducts() async -> Result<ProductRoot, APIError> {
        return await manager.execute(ProductEndpoint.getProducts)
    }
   }```

5. Then start Repository in your **ViewModel** as:

        ```let productRepository: ProductRepository
        init(productRepository: ProductRepository = ProductRepository.shared) {
            self.productRepository = productRepository
        }
        func getProductsRequest() async {
            print("------getProductsRequest------")
            Task {
                let result = await self.productRepository.fetchProducts()
                self.isLoading = false
                switch result {
                case let .success(products):
                    self.products = products
                    print("-------getProductsRequest.Success-----")
                    print(self.products)
                case let .failure(error):
                    print("getProductsRequest.fail: \(error)")

                }
            }
         }```







