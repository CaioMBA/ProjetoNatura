import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../Domain/ProductModels.dart';

class ProductTile extends StatelessWidget {
  final GetFutureProductModel product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.deepOrange[50],
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(product.Photo!, height: 140)),
          StrokeText(
            text: product.Name!.substring(0, 15),
            textStyle:
                GoogleFonts.dmSerifDisplay(fontSize: 20, color: Colors.green),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: StrokeText(
              text:'R\$ ${product.Value!.toStringAsFixed(2).toString().replaceAll('.', ',')}',
              textStyle: GoogleFonts.dmSerifDisplay(color: Colors.blue,fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
