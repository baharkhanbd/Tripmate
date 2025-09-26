class AppURl {
  // static String get _baseUrl => "http://192.168.0.105:8000";
  // static String get _baseUrl => "https://cardmaker.edubd.online";
  static String get _baseUrl => "https://ppp7rljm-8000.inc1.devtunnels.ms";
   static String get baseUrl => "https://ppp7rljm-8000.inc1.devtunnels.ms";
  // static String get _baseUrl => "https://dummyjson.com";
  // static String get loginUrl => "$_baseUrl/auth/login";
  static String get loginUrl => "$_baseUrl/api/users/login/";

  static String get logOutUrl => "$_baseUrl/logout/";

  static String get studentList => "$_baseUrl/school/student_list/";

  static String get teacherList => "$_baseUrl/school/teacher_list/";

  static String get institutList => "$_baseUrl/school/institutes/";

  static String get avaterUpdate => "$_baseUrl/update_avatar/";

  static String get employeeAvaterUpdate => "$_baseUrl/update_teacher_avatar/";

  static String avaterUrt(String url) => "$_baseUrl$url";

  static String classList(String instituteId) => "$_baseUrl/school/student_classes/?institute_id=$instituteId";

  static String sectionList(String instituteId) => "$_baseUrl/school/student_sections/?institute_id=$instituteId";

  static String classAndSectionWiseStudentList({required String instituteId, required String classId, required String sectionId}) => "$_baseUrl/student_list_classwise/?institute_id=$instituteId&class_id=$classId&section_id=$sectionId";
}