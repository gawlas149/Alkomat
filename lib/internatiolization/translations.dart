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
    'sort': 'Sort',
    'sort_az': 'From A to Z',
    'sort_za': 'From Z to A',
    'sort_ml+': 'Increasing ml',
    'sort_ml-': 'Decreasing ml',
    'sort_perc+': 'Increasing %',
    'sort_perc-': 'Decreasing %',
    'okey': 'Okey',
    'reaction': 'Reaction to per mille',
    'drunk1': 'You are completely sober',
    'drunk2':
        'You are sober enough to drive a car in Poland\nYou may feel a slight change in mood',
    'drunk3':
        'Your eye-hand coordination is impaired\nYou start to lose your balance\nYou may experience euphoria\nDo not drive any vehicle!',
    'drunk4':
        'Your motor skills are impaired\You are hyperactive and talkative\Your self-control is reduced\nYou incorrectly assess your capabilities',
    'drunk5':
        'You are experiencing balance problems\nYour intellectual performance is declining\nYour reaction time is delayed\nYou are irritable\nYou have high blood pressure',
    'drunk6':
        'Your speech sounds like gibberish\You fall over\You feel increased drowsiness\You cannot control your own behavior',
    'drunk7':
        'Your blood pressure drops\Your body temperature drops\You lose your physiological reflexes',
    'drunk8': 'You are in a coma or already dead',
    'drunk9': "You're dead\nThe party was definitely worth it",
    'cancel': 'Cancel',
    'beer': 'Beer',
    'vodka': 'Vodka',
    'wine': 'Vine',
    'champagne': 'Champagne',
    'moonshine': 'Moonshine',
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
    'sort': 'Sortuj',
    'sort_az': 'Od A do Z',
    'sort_za': 'Od Z do A',
    'sort_ml+': 'Rosnące ml',
    'sort_ml-': 'Malejące ml',
    'sort_perc+': 'Rosnący %',
    'sort_perc-': 'Malejący %',
    'okey': 'Okej',
    'reaction': 'Reakcja na promile',
    'drunk1': 'Jesteś kompletnie trzeźwy',
    'drunk2':
        'Jesteś na tyle trzeźwy by móc w Polsce prowadzić samochód\nMożesz czuć niewielką zmianę nastroju',
    'drunk3':
        'Twoja koordynacja wzrokowo-ruchowa jest zaburzona\nRozpoczyna się tracenie równowagi\nMożesz przeżywać euforię\nNie prowadź żadnego pojazdu!',
    'drunk4':
        'Twoja sprawność ruchowa jest zaburzona\nJesteś nadpobudliwy i gadatliwy\nTwoja samokontrola jest obniżona\nBłędnie oceniasz swoje możliwości',
    'drunk5':
        'Przeżywasz zaburzenia równowagi\nSpada Twoja sprawność intelektualna\nTwój czas reakcji jest opóźniony\nJesteś drażliwy\nMasz wysokie ciśnienie krwi',
    'drunk6':
        'Twoja mowa przypomina bełkot\nPrzerwacasz się\nCzujesz wzmożoną senność\nNie kontrolujesz własnych zachowań',
    'drunk7':
        'Spada Twoje ciśnienie krwi\nSpada Twoja temperatura ciała\nTracisz odruchy fizjologiczne',
    'drunk8': 'Jesteś w śpiączce lub już nie żyjesz',
    'drunk9': 'Nie żyjesz\nImpreza na pewno była tego warta',
    'cancel': 'Anuluj',
    'beer': 'Piwo',
    'vodka': 'Wódka',
    'wine': 'Wino',
    'champagne': 'Szampan',
    'moonshine': 'Bimber dziadka',
  };
}
