/// Returns DateTime as a int as `YYYYMM` format
int getYearMonth({DateTime? date}) {
  DateTime now;
  if (date != null) {
    now = date;
  } else {
    now = DateTime.now();
  }
  var m = now.month.toString();
  if (m.length == 1) {
    m = '0$m';
  }
  return int.parse("${now.year}$m");
}
