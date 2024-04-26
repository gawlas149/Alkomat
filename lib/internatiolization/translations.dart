import 'package:get/get.dart';

class ApplicationTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      <String, Map<String, String>>{'en_US': _enUS, 'pl_PL': _plPL};

  final Map<String, String> _enUS = <String, String>{
    'main_screen': 'Main Screen',
    'main_screen_info1':
        'The purpose of the application is to measure the concentration of alcohol in your blood during a party\n\nControl how drunk you are by systematically updating the drinks consumed\n\n',
    'main_screen_info2':
        'In order for the application to work more effectively, we need some information about you:',
    'your_weight': 'Your weight [kg]',
    'your_limit': 'Your limit of alcohol [‰]',
    'your_gender': 'Your gender:',
    'male': 'Male',
    'female': 'Female',
    'breathalyser': 'Breathalyser',
    'choose_time': 'Select the time when the libation began',
    'end': 'End of party',
    'add_liquor': 'Add liquor',
    'percentage_in_blood': '@percentage‰ in blood',
    'end_no': 'No :D',
    'end_yes': 'Yes :c',
    'end_question':
        '\nAre you sure the party is over?\Confirmation will clear the alcohol list',
    'liquor_name': 'Liquor name',
    'liquor_voltage': 'Liquor voltage [%]',
    'liquor_volume': 'Liquor volume [ml]',
    'liquor_save': 'Save liquor',
    'edit_liquor': 'Edit liquor',
    'liquor_delete': 'Delete liquor',
  };

  final Map<String, String> _plPL = <String, String>{
    'main_screen': 'Strona główna',
    'main_screen_info1':
        'Celem aplikacji jest mierzenie stężenia alkoholu we krwi w trakcie imprezy\n\nKontroluj jak bardzo jesteś pijany poprzez systematyczne aktualizowanie wypitych trunków\n\n',
    'main_screen_info2':
        'Aby aplikacja działała skuteczniej potrzebujemy paru informacji o Tobie:',
    'your_weight': 'Twoja waga [kg]',
    'your_limit': 'Twój limit alkoholu [‰]',
    'your_gender': 'Twoja płeć:',
    'male': 'Mężczyzna',
    'female': 'Kobieta',
    'breathalyser': 'Alkomat',
    'choose_time': 'Wybierz czas rozpoczęcia libacji',
    'end': 'Koniec imprezy',
    'add_liquor': 'Dodaj trunek',
    'percentage_in_blood': '@percentage‰ we krwi',
    'end_no': 'Nie :D',
    'end_yes': 'Tak :c',
    'end_question':
        '\nCzy impreza na pewno się zakończyła?\nPotwierdzenie spowoduje wyczyszczenie listsy alkoholi',
    'liquor_name': 'Nazwa trunku',
    'liquor_voltage': 'Woltaż trunku [%]',
    'liquor_volume': 'Objętość trunku [ml]',
    'liquor_save': 'Zapisz trunek',
    'edit_liquor': 'Edytuj trunek',
    'liquor_delete': 'Usuń trunek',
  };
}
