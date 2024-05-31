class User {
  User({
    required this.id,
    required this.name,
    required this.company_name,
    required this.mobile_no,
    required this.email_id,
    required this.address,
    required this.billing_address,
    required this.sys_username,
    required this.sys_culture,
    required this.user_type,
    required this.map_id,
    required this.plan_id,
    required this.domain_id,
    required this.timezone_id,
    required this.currency_id,
    required this.date_format,
    required this.is_active,
  });

  int id;
  String name;
  String company_name;
  String mobile_no;
  String email_id;
  String address;
  String billing_address;
  String sys_username;
  String sys_culture;
  int user_type;
  int map_id;
  int plan_id;
  int domain_id;
  int timezone_id;
  int currency_id;
  String date_format;
  int is_active;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        company_name: json["company_name"],
        mobile_no: json["mobile_no"],
        email_id: json["email_id"],
        address: json["address"],
        billing_address: json["billing_address"],
        sys_username: json["sys_username"],
        sys_culture: json["sys_culture"],
        user_type: json["user_type"],
        map_id: json["map_id"],
        plan_id: json["plan_id"],
        domain_id: json["domain_id"],
        timezone_id: json["timezone_id"],
        currency_id: json["currency_id"],
        date_format: json["date_format"],
        is_active: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company_name": company_name,
        "mobile_no": mobile_no,
        "email_id": email_id,
        "address": address,
        "billing_address": billing_address,
        "sys_username": sys_username,
        "sys_culture": sys_culture,
        "user_type": user_type,
        "map_id": map_id,
        "plan_id": plan_id,
        "domain_id": domain_id,
        "timezone_id": timezone_id,
        "currency_id": currency_id,
        "date_format": date_format,
        "is_active": is_active,
      };
}
