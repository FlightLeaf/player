import 'package:mysql1/mysql1.dart' as mysql;

class MySQLUtils {
  static Future<mysql.Results> database(String sql) async {
    var settings = mysql.ConnectionSettings(
      host: 'rm-cn-wwo39zbqi000uvlo.rwlb.rds.aliyuncs.com',
      port: 3306,
      user: 'player',
      password: 'Player123',
      db: 'player',
    );
    var conn = await mysql.MySqlConnection.connect(settings);
    var results = await conn.query(sql);
    await conn.close();
    return results;
  }
}
