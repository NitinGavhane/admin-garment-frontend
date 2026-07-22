import 'dart:convert';
import 'dart:io';

// The live AWS-hosted API (CloudFront in front of the EC2 backend). Must stay
// in step with ApiConfig.baseUrl.
const String baseUrl = 'https://d100c6f2kgsym4.cloudfront.net/api/v1';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stdout.writeln('Usage: dart run scripts/seed_products.dart <email> <password>');
    exit(1);
  }

  final email = args[0];
  final password = args[1];

  stdout.writeln('Logging in as $email...');
  final token = await login(email, password);
  stdout.writeln('Login successful!\n');

  for (var i = 0; i < products.length; i++) {
    final product = products[i];
    stdout.writeln(
        '[${i + 1}/${products.length}] Creating "${product['title']}"...');
    try {
      await createProduct(product, token);
      stdout.writeln('  -> Done');
    } catch (e) {
      stderr.writeln('  -> Failed: $e');
    }
  }

  stdout.writeln('\nAll products processed!');
}

Future<String> login(String email, String password) async {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 30);

  try {
    final request = await client.postUrl(Uri.parse('$baseUrl/admin/login'));
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'email': email, 'password': password}));

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      throw HttpException(
          'Login failed (${response.statusCode}): $body');
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    return data['access_token'] as String;
  } finally {
    client.close();
  }
}

Future<void> createProduct(
    Map<String, dynamic> product, String token) async {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 30);

  try {
    final request =
        await client.postUrl(Uri.parse('$baseUrl/admin/products'));
    request.headers.contentType = ContentType.json;
    request.headers.set('Authorization', 'Bearer $token');
    request.write(jsonEncode(product));

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw HttpException(
          'Failed to create product (${response.statusCode}): $body');
    }
  } finally {
    client.close();
  }
}

const List<Map<String, dynamic>> products = [
  {
    "category_id": "western-wear",
    "title": "Effortless Chic Western Outfit",
    "description":
        "Stylish western wear outfit designed for casual outings, brunch dates, and everyday fashion. Features a modern chic look with comfortable styling.",
    "brand": "FashionHub",
    "sku": "WW-001",
    "price": 2499,
    "discount_price": 1999,
    "stock": 50,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0},
      {"size": "XL", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/d684b053-2069-4bd1-a77b-629f308257fd/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "western-wear",
    "title": "Effortless Chic Fashion Set",
    "description":
        "Elegant western fashion set crafted for a trendy and sophisticated appearance suitable for multiple occasions.",
    "brand": "FashionHub",
    "sku": "WW-002",
    "price": 2599,
    "discount_price": 2099,
    "stock": 45,
    "featured": false,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/d684b053-2069-4bd1-a77b-629f308257fd/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "co-ord-set",
    "title": "Women's Designer Co-ord Set",
    "description":
        "Fashionable co-ord set featuring matching top and bottom designed for modern and comfortable styling.",
    "brand": "StyleCraft",
    "sku": "CS-001",
    "price": 2999,
    "discount_price": 2499,
    "stock": 40,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0},
      {"size": "XL", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/f667b4c0-0e34-44d8-b321-6e3923d1dcb1/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "formal-wear",
    "title": "Cream Shirt with Brown Pants Combo",
    "description":
        "Classic formal outfit featuring a cream-colored shirt paired with stylish brown trousers for office and casual events.",
    "brand": "UrbanWear",
    "sku": "FW-001",
    "price": 2799,
    "discount_price": 2299,
    "stock": 35,
    "featured": true,
    "is_active": true,
    "gender": "Men",
    "variants": [
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0},
      {"size": "XL", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/accb76ea-18e1-4255-9773-a120be7b32ee/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "sarees",
    "title": "Women's Embroidered Saree",
    "description":
        "Premium embroidered saree featuring elegant craftsmanship suitable for weddings, festivals, and special occasions.",
    "brand": "EthnicElegance",
    "sku": "SAR-001",
    "price": 3499,
    "discount_price": 2899,
    "stock": 25,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"color": "Pink", "stock": 0},
      {"color": "Red", "stock": 0},
      {"color": "Cream", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/aacf227f-05da-4552-a21f-73aae5566c73/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "jeans",
    "title": "High Waist Wide Leg Baggy Jeans",
    "description":
        "Trendy high-waist wide-leg baggy jeans designed for streetwear fashion and everyday comfort.",
    "brand": "DenimVerse",
    "sku": "JNS-001",
    "price": 2199,
    "discount_price": 1799,
    "stock": 60,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "28", "stock": 0},
      {"size": "30", "stock": 0},
      {"size": "32", "stock": 0},
      {"size": "34", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/7d57280f-9125-4cb4-97ab-9ebc9c5ebf37/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "footwear",
    "title": "Women's High Heel Bow Sandals",
    "description":
        "Elegant closed-toe high heel sandals featuring a decorative bow design. Perfect for parties and summer fashion.",
    "brand": "LuxeStep",
    "sku": "FTW-001",
    "price": 1999,
    "discount_price": 1599,
    "stock": 50,
    "featured": false,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "36", "stock": 0},
      {"size": "37", "stock": 0},
      {"size": "38", "stock": 0},
      {"size": "39", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/3396de3c-7f01-4c6c-9b89-0df650c01704/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "western-dress",
    "title": "GRECIILOOKS Maxi Dress",
    "description":
        "Stylish maxi dress designed for casual wear, parties, and summer outings with a comfortable long-flowing silhouette.",
    "brand": "GRECIILOOKS",
    "sku": "MXD-001",
    "price": 2899,
    "discount_price": 2399,
    "stock": 45,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0},
      {"size": "XL", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/d7cf886d-4584-4621-a31d-f1d2181a3dfc/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "ethnic-wear",
    "title": "Vibrant Indian Fashion Outfit",
    "description":
        "Contemporary Indian ethnic wear inspired by vibrant traditional fashion styles suitable for festive occasions.",
    "brand": "DesiTrendz",
    "sku": "ETH-001",
    "price": 3299,
    "discount_price": 2699,
    "stock": 30,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/2f7212d1-6a86-44d2-8101-19aa6abe3d4f/image.png",
        "is_primary": true
      }
    ]
  },
  {
    "category_id": "western-wear",
    "title": "Long Skirt and Top Set",
    "description":
        "Elegant long skirt paired with a matching top, offering a stylish and comfortable outfit for casual and festive occasions.",
    "brand": "FashionHub",
    "sku": "LST-001",
    "price": 2699,
    "discount_price": 2199,
    "stock": 40,
    "featured": true,
    "is_active": true,
    "gender": "Women",
    "variants": [
      {"size": "S", "stock": 0},
      {"size": "M", "stock": 0},
      {"size": "L", "stock": 0},
      {"size": "XL", "stock": 0}
    ],
    "images": [
      {
        "image_url":
            "https://1009cv4u59.ucarecd.net/c10e41c3-e380-45e8-842e-3f1926cd2db6/image.png",
        "is_primary": true
      }
    ]
  }
];
