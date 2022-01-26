class CategorieModel {
  String categorieName;
  String imgUrl;
}

List<CategorieModel> getCategories() {
  List<CategorieModel> categories = [];
  CategorieModel categorieModel = CategorieModel();
  //
  categorieModel.imgUrl = "assets/images/category/category1.jpeg";
  categorieModel.categorieName = "Books";

  categories.add(categorieModel);
  categorieModel = CategorieModel();

  //
  categorieModel.imgUrl = "assets/images/category/category2.jpeg";
  categorieModel.categorieName = "Videos";

  categories.add(categorieModel);
  categorieModel = CategorieModel();

  //
  categorieModel.imgUrl = "assets/images/category/category1.jpeg";
  categorieModel.categorieName = "Packages";

  categories.add(categorieModel);
  categorieModel = CategorieModel();

  //
  categorieModel.imgUrl = "assets/images/category/category2.jpeg";
  categorieModel.categorieName = "Library";

  categories.add(categorieModel);
  categorieModel = CategorieModel();

  return categories;
}
