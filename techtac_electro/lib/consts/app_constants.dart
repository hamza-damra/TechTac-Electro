import 'package:techtac_electro/models/categories_model.dart';
import 'package:techtac_electro/services/assets_manager.dart';

class AppConstants {
  static const String productImageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "IOT",
      image: AssetsManager.iot,
      name: "IOT",
    ),
    CategoryModel(
      id: "Sensors",
      image: AssetsManager.sensor,
      name: "Sensors",
    ),
    CategoryModel(
      id: "Wireless",
      image: AssetsManager.network,
      name: "Wireless",
    ),
    CategoryModel(
      id: "RaspberryPi",
      image: AssetsManager.raspberry,
      name: "RaspberryPi",
    ),
    CategoryModel(
      id: "Arduino",
      image: AssetsManager.arduino,
      name: "Arduino",
    ),
    CategoryModel(
      id: "Display",
      image: AssetsManager.display,
      name: "Display",
    ),
    CategoryModel(
      id: "Components",
      image: AssetsManager.components,
      name: "Components",
    ),
    CategoryModel(
      id: "Modules",
      image: AssetsManager.modules,
      name: "Modules",
    ),
  ];
}
