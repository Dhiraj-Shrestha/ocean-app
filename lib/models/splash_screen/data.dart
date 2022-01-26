class SliderModel {
    String imageAssetPath;
    String title;
    String desc;

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setDesc(
      "The only thing you absolutely have to know is the location of the library");
  sliderModel.setTitle("Search");
  sliderModel.setImageAssetPath("assets/images/1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //2
  sliderModel.setDesc(
      "Read the best books first, or you may not have a chance to read them to all.");
  sliderModel.setTitle("Order");
  sliderModel.setImageAssetPath("assets/images/2.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //3
  sliderModel.setDesc(
      "Reading is a conversation. All books talk. But a good book listens as well");
  sliderModel.setTitle("Reading");
  sliderModel.setImageAssetPath("assets/images/1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  return slides;
}
