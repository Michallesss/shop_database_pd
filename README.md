# shop_database_pd

Baza:
Należy utworzyć bazę danych z następującymi tabelami:
- Producent - opisującej producenta danego produktu
- Produkt - opisującej dany produkt wraz z ceną i relacyjne powiązanie z tabelą Producent
- Klient - opisującej danego klienta wraz z adresem 
- Zamówienie - opisującej zamówienie oraz połączeniem relacyjnym do tabeli Klient
- Koszyk - tabela łącząca tabele Zamówienie oraz Produkt wraz z ilością zamawianego produktu
W bazie danych należy zaproponować odpowiednie pola, relacje oraz dodać testowe (wpisy) do powyższych tabel.
Dla każdej tabeli w której znajduje się chociaż 1 klucz obcy należy utworzyć widok zastępując pole numeryczne odpowiednią nazwą z tabeli powiązanej np.:
tabela Produkt zawiera pole id_producenta typu int i zamieniamy to pole na odpowiadającą mu nazwę producenta z tabeli Producent

Procedura `koszykpr`:
Do bazy danych sklep (z zadania poprzedniego) należy utworzyć procedurę dodającą produkt do koszyka w następujący sposób:
- Jeżeli produkt już jest w koszyku edytujemy jego ilość
- W przeciwnym wypadku dodajemy nowy wpis do tabeli koszyk
Parametry przekazywane do procedury to:
- id_produktu
- id_zamowienia
- ilosc_sztuk
