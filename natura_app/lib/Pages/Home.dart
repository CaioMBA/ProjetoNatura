import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natura_app/Services/ProductServices.dart';
import 'package:natura_app/Themes/Colors.dart';
import 'package:stroke_text/stroke_text.dart';

import '../Components/CommonModalDrop.dart';
import '../Components/CustomAppBar.dart';
import '../Components/CustomNavigationDrawer.dart';
import '../Components/ImageContainerBox.dart';
import '../Components/ItemTile.dart';
import '../Domain/ProductModels.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ChoiceController = TextEditingController();

  List ProductMenu = [
    GetFutureProductModel(
        Name: 'Kaiak Aero Desodorante Colônia Masculino',
        Value: 155.9,
        Photo:
            'https://static.natura.com/cdn/ff/LvgBVANF9U_nceNHC4agkyiapKDLyqQF_TzpPRetRNg/1696261588/public/products/108404_7.jpg'),
    GetFutureProductModel(
        Name: 'Essencial Ato Deo Parfum Masculino',
        Value: 239,
        Photo:
            'https://static.natura.com/cdn/ff/deJdk9vR5vCQI2P-ZB6Yosc1iwPlxY_J-dmpHCnbdjE/1695195777/public/products/114584_3.jpg'),
    GetFutureProductModel(
        Name: 'Química de Humor Desodorante Colônia Masculino',
        Value: 134.91,
        Photo:
            'https://static.natura.com/cdn/ff/VKJdxPvZzobDKAENNEwcwIUjPZ1bKS-L1KtolMzmxvk/1695204690/public/products/70996_0.jpg')
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  GetContainer(String x) async {
    GetFutureProductModel? Values = await GetFutureProductService(x);
    if (Values != null) {
      if (Values.ID != null) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ImageContainerBox(
                description: Values.Name!,
                value: Values.Value,
                ImageInf: Values.Photo,
              );
            });
      } else {
        Navigator.pop(context);
        ImageContainerBox(
          description: "Nenhum Produto Encontrado",
          value: 0,
        );
      }
    }
  }

  ShowBox() async {
    List<GetProductTypes?> ResponseMap = await GetTypesList();
    Map<String, String?> productTypeMap = {};

    for (var productType in ResponseMap) {
      if (productType != null) {
        productTypeMap[productType.producttypeid.toString()] = productType.type;
      }
    }

    ChoiceController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return CommonModalDrop(
            DpItems: productTypeMap,
            SelectedValue: '1',
            onChanged: (String x) {
              GetContainer(x);
            },
            Title: 'Escolha o TIPO de produto',
            Label: '',
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: CustomAppBar(Title: 'Home'),
        drawer: const CustomNavigationDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'lib/Images/background-green_pink_leaves.jpeg'),
                    fit: BoxFit.cover)),
            child: SafeArea(
                child: Center(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  padding: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          StrokeText(
                            text: 'Já viu nossa nova IA?',
                            textStyle: GoogleFonts.dmSerifDisplay(
                                fontSize: 20, color: primaryColor ),
                            strokeColor: Colors.black,
                            strokeWidth: 2,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          FloatingActionButton.extended(
                            icon: Icon(Icons.card_giftcard),
                            label: Text('Use a IA =>'),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            onPressed: ShowBox,
                          )
                        ],
                      ),
                      Image.asset(
                        'lib/Images/natura-logo.png',
                        height: 50,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(40)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(40))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: StrokeText(
                    text: 'Produtos:',
                    textStyle: GoogleFonts.alatsi(
                        fontSize: 30, color: Colors.orangeAccent),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ProductMenu.length,
                      itemBuilder: (context, index) => ProductTile(
                            product: ProductMenu[index],
                          )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent[400],
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04,
                      bottom: MediaQuery.of(context).size.height * 0.02),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://static.natura.com/cdn/ff/37AO326_4_BUDKrbYOjRTyxAf1owK1SqOJtjhwwLXgw/1696260293/public/products/57525_0.jpg',
                            height: 60,
                          )),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('K Deo Parfum Masculino',
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 18, color: Colors.white)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Text(
                            'R\$ 239,00',
                            style: TextStyle(color: Colors.green[200]),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )))));
  }
}
