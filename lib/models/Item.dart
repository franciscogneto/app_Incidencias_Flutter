class Item{
  String title;
  bool checked;

  Item({this.title,this.checked});

  //String toString() => "{title: $title, value: $checked}";

  Map<String,dynamic> toJson() => {
    'title':this.title,
    'checked':this.checked,
  };

  static Item fromJson(dynamic element){
    final Map<String,dynamic> aux = element;
    return new Item(
    checked : aux['checked'],
    title : aux['title']
    );
  }

  static List<Item> fromMap(List<dynamic> message){

    //print(message);
    List<Item> aux = new List<Item>();
    message.forEach((element) {
      aux.add(Item.fromJson(element));
    });

    return aux;
  }

  @override
  String toString() {

    return '{checked:$checked,'
        'title:$title}';
  }
}