with log; 
use log; 
with losowe; 
with nadzor; 

package body rozladunek is 

   task body rampa is 
      G : losowe.generator;
      bufor : array (0 .. pojemnosc_rampy - 1) of partia; 
      poczatek : Natural := 0; 
      liczba : Natural := 0; 
      zamknieta : Boolean := False; 
      biezaca : dostawa; 

      procedure podziel_na_partie (D : dostawa) is
         reszta : Natural := D.ilosc;
         ile : Natural; 
         partii : Natural := 0;

      begin 
         while reszta > 0 loop 
            ile := natural'min (reszta, max_parti);
            bufor ((poczatek + liczba) mod pojemnosc_rampy) :=
               (id_dostawy => D.id, rodzaj => D.rodzaj, ilosc => ile);
            liczba := liczba + 1;
            reszta := reszta - ile; 
            partii := partii + 1; 
         end loop;
         pisz ("rampa: D" & Img (D.id) & " podzielona na " & Img (partii) & " partie, czeka na roboty: " & Img (liczba) & "/" & Img (pojemnosc_rampy));
      end podziel_na_partie;

      begin
         losowe.inicjuj (G, 400); 
         loop 
            select
               when liczba <= pojemnosc_rampy - max_parti_dostawy =>
                  accept zglos (D : dostawa) do 
                     pisz ("rozpoczeto rozladunek D" & Img (D.id) & " (w kolejce czekaja: " & Img (zglos'Count) & ")", zolty);
                     delay 1.0 + 0.08 * D.ilosc + losowe.czas (G, 0.0, 0.5);
                     pisz ("zakonczono rozladunek D" & Img (D.id), zolty);
                     biezaca := D; 

                  end zglos;
                  podziel_na_partie (biezaca);
                  nadzor.monitor.dostawa_obsluzona;
               or 
                  when liczba > 0 or else zamknieta =>
                     accept pobierz_partie (P : out partia; koniec : out Boolean) do 
                        koniec := liczba = 0; 
                        if liczba > 0 then 
                           P := bufor (poczatek); 
                           poczatek := (poczatek + 1) mod pojemnosc_rampy;
                           liczba := liczba - 1; 
                        else 
                            P := (others => <>);
                        end if; 
                     
                     end pobierz_partie; 
               or 
                  when not zamknieta => 
                     accept zamknij do
                        zamknieta := True; 
                        pisz ("rampa zamknieta");
                     end zamknij;
               or 
                  terminate;
               end select;
            end loop;
         end rampa; 


end rozladunek;
