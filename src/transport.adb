with log;          use log;
with typy;         use typy;
with rozladunek;   
with magazynowanie;
with losowe;
with nadzor;

package body Transport is

   task body Robot is
      G        : losowe.generator;
      moje_id  : id_robota;
      P        : partia;
      koniec   : Boolean := False;
      stan     : stany := wylaczony;
      
      --procedura poinformawania monitora o zmianie stanu
      procedure zmien_stan (nowy_stan : stany) is
      begin
         stan := nowy_stan;
         nadzor.monitor.zglos_stan (moje_id, stan);
      end zmien_stan;
      
      begin
      accept start (id : id_robota) do
         moje_id := id;
      end start;

      --init generatora liczb losowych dla robota
      losowe.inicjuj (G, 100 + moje_id);
      stan := wolny;
      pisz ("Robot " & Img (moje_id) & " gotowy do pracy", cyjan);

      loop
         --robot prosi rampe o ladunek
         rozladunek.rampa.pobierz_partie (P, koniec);

         --sprawdzenie czy rampa zamknieta i nie ma towru
         if koniec then
            zmien_stan (wylaczony);
            pisz ("Robot R" & Img (moje_id) & " zakonczyl prace", cyjan);
            exit; 
         end if;

         --robot pobral partie
         zmien_stan (jedzie);
         pisz ("Robot " & Img (moje_id) & " pobral " & Img (P.ilosc) & " szt. "
               & Nazwa (P.rodzaj) & " (Dostawa D" & Img (P.id_dostawy) & ")", cyjan);
         
         delay losowe.czas(G, 1.0, 2.5);
         zmien_stan (czeka);
         --przekazanie towaru do magazynu
         magazynowanie.magazyn.przyjmij (P.rodzaj, P.ilosc);
         --powrot po next partie
         zmien_stan (wraca);
         delay losowe.czas (G, 0.5, 1.5);
         zmien_stan(wolny);

      end loop;
   end Robot;
end Transport;
         