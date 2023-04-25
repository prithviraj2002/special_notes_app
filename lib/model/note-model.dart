class Note{
  final String title;
  final String desc;
  final int id;

    Note({
      required this.title,
      required this.desc,
      required this.id
    });

    Map<String, dynamic> toMap(){
      return {
        'id': id,
        'title' : title,
        'desc' : desc
      };
    }

}