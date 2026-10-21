with Log;  use Log;
with Losowe;
with Magazynowanie;
with Nadzor;
with Rozladunek;

package body Transport is

   task body Robot is
      G       : Losowe.Generator;
      Moje_Id : Id_Robota;
      P       : Partia;
      Koniec  : Boolean := False;
      Proby   : Natural;

      --  Procedura informowania monitora o zmianie stanu
      procedure Zmien_Stan (Nowy_Stan : stany) is
      begin
         Nadzor.Monitor.Zglos_Stan (Moje_Id, Nowy_Stan);
      end Zmien_Stan;

   begin
      accept Start (Id : Id_Robota) do
         Moje_Id := Id;
      end Start;

      --  Inicjalizacja generatora liczb losowych dla robota
      Losowe.Inicjuj (G, 100 + Moje_Id);
      Pisz ("Robot R" & Img (Moje_Id) & " gotowy do pracy", Cyjan);

      loop
         Rozladunek.Rampa.Pobierz_Partie (P, Koniec);

         if Koniec then
            Zmien_Stan (Wylaczony);
            Pisz ("Robot R" & Img (Moje_Id) & " zakończył pracę", Cyjan);
            exit;
         end if;

         Zmien_Stan (Jedzie);
         Pisz ("Robot R" & Img (Moje_Id) & " pobrał " & Img (P.Ilosc)
               & " szt. " & Nazwa (P.Rodzaj) & " (dostawa D"
               & Img (P.id_dostawy) & ")", Cyjan);
         delay Losowe.Czas (G, 1.0, 2.5);

         Proby := 0;
         loop
            select
               Magazynowanie.Magazyn.Przyjmij (P.Rodzaj, P.Ilosc);
               Pisz ("Robot R" & Img (Moje_Id) & " dostarczył towar", Cyjan);
               exit;
            or
               delay 2.0 * Tempo;
               Proby := Proby + 1;
               if Proby = 1 then
                  Zmien_Stan (Czeka);
               end if;
               if Proby >= Proby_Magazynu then
                  Pisz ("Robot R" & Img (Moje_Id) & ": magazyn wciąż pełny"
                        & " - partia odesłana do magazynu zewnętrznego",
                        Czerwony);
                  exit;
               end if;
               Pisz ("Robot R" & Img (Moje_Id)
                     & " czeka - brak miejsca w magazynie", Szary);
            end select;
         end loop;

         Zmien_Stan (Wraca);
         delay Losowe.Czas (G, 0.5, 1.5);
         Zmien_Stan (Wolny);
      end loop;
   end Robot;

end Transport;
         