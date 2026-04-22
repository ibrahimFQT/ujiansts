import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // ambil data dari API
  Future<List> getData() async {
    var response = await http.get(
      Uri.parse("https://dummyjson.com/products?limit=10"),
    );

    var data = json.decode(response.body);
    return data['products'];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],

        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("shoope"),
        ),

        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {

            // loading
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List products = snapshot.data!;

            return GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: products.length,

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),

              itemBuilder: (context, index) {
                var p = products[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [

                      // FOTO
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.network(
                            p['thumbnail'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // NAMA
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          p['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // RATING
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star,
                              size: 14, color: Colors.orange),
                          SizedBox(width: 3),
                          Text("${p['rating']}"),
                        ],
                      ),

                      // HARGA
                      Text(
                        "Rp ${p['price']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // STOK
                      Text(
                        "Stok ${p['stock']}",
                        style: TextStyle(fontSize: 12),
                      ),

                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}