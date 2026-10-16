package typy is
   
type Towar is (szczepionki, antybiotyki, opatrunki);
type Priorytet is (zwykly, pilne);
type Stany is (wolny, jedzie,  czeka, wraca, wylaczony);

liczba_samochodow : constant := 10;
liczba_robotow : constant := 3; 
liczba_szpitali : constant := 2; 
liczba_aptek : constant := 3; 
zamowienia_szpitala : constant := 5; 
zamowienia_aptek : constant := 6;
pojemnosc_magazynu : constant := 80; 
zapas_poczatkowy : constant := 8; 
max_parti : constant := 10; 
max_dostawy : constant := 30; 
min_dostawy : constant := 10; 
max_parti_dostawy : constant := (max_dostawy + max_parti - 1) /max_parti;
pojemnosc_rampy : constant := 6; 
max_oczekujacych : constant := 8;
proby_magazynu : constant := 5; 
okres_raportu : constant duration := 6.0; 


subtype id_robota is Positive range 1 .. liczba_robotow;


type dostawa is record 
   id : Positive := 1; 
   rodzaj : Towar := Towar'First;
   ilosc : Positive := 1; 
end record;

type partia is record 
   id_dostawy : Natural := 0; 
   rodzaj : Towar := Towar'First;
   ilosc : Natural := 0; 
end record; 

type zamowienie is record
   klient : Positive := 1;
   nr : Positive := 1;
   rodzaj : towar := Towar'First;
   ilosc : Positive := 1; 
   prio : Priorytet := zwykly;
end record; 

type ilosc is array (Towar) of Natural; 
type liczniki is array (Priorytet) of Natural; 

type stan_magazynu is record
   zapas : ilosc := (others => 0);
   zapelnienie : natural := 0;
   zlozone : liczniki := (others => 0);
   zrealizowane : liczniki := (others => 0);
   oczekujace : liczniki := (others => 0);
   odrzucone : liczniki := (others => 0);
end record;

function Nazwa (T : Towar) return Wide_Wide_String;
function Nazwa (P : Priorytet) return Wide_Wide_String;
function Nazwa (S : Stany) return Wide_Wide_String;
function Nazwa (Z : zamowienie) return Wide_Wide_String;

end typy;