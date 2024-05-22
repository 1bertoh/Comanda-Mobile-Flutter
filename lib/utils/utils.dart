class Utils{
  Utils();
  static formattedDateTime(String inputDate){
    //formato esperado:  2023-11-16 00:00:00.000
    try{
        DateTime dateTime = DateTime.parse(inputDate);

        // Formato desejado: '16/11/2023 00:00'
        String formattedDateTime =
            '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

        return formattedDateTime;
    } catch(e){
      return 'Data inválida';
    }
  }
}