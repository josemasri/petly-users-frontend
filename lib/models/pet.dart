class Pet {
    int id;
    String animal;
    String name;
    int age;
    String imageUrl;
    String description;
    DateTime createdAt;
    int userId;
    String userFirstName;
    String userLastName;
    String userCountry;
    String userState;
    String userCounty;
    DateTime userCreatedAt;

    Pet({
        this.id,
        this.animal,
        this.name,
        this.age,
        this.imageUrl,
        this.description,
        this.createdAt,
        this.userId,
        this.userFirstName,
        this.userLastName,
        this.userCountry,
        this.userState,
        this.userCounty,
        this.userCreatedAt,
    });

    factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json["id"],
        animal: json["animal"],
        name: json["name"],
        age: json["age"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        userId: json["userId"],
        userFirstName: json["userFirstName"],
        userLastName: json["userLastName"],
        userCountry: json["userCountry"],
        userState: json["userState"],
        userCounty: json["userCounty"],
        userCreatedAt: DateTime.parse(json["userCreatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "animal": animal,
        "name": name,
        "age": age,
        "imageUrl": imageUrl,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "userId": userId,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userCountry": userCountry,
        "userState": userState,
        "userCounty": userCounty,
        "userCreatedAt": userCreatedAt.toIso8601String(),
    };
}