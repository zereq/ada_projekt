with Log; use Log;
with Losowe;
with Magazynowanie;
with Typy; use Typy;

package body Klienci is

   task body Szpital is
      G: Losowe.generator;
      Z: Zamowienie := (Prio=>Pilne, others=> <>);
      begin
         accept Start (Nr: Positive) do
            Z.klient := Nr;
         end Start;
         
         Losowe.inicjuj (G, 200+Z.klient);

         for K in 1 .. zamowienia_szpitala loop
            delay Losowe.czas(G, 4.0, 10.0);
            Z.nr := K;
            Z.rodzaj := Losowe.losowy_towar(G);
            Z.ilosc := Losowe.liczba(G, 5, 15);
            Pisz ("Szpital S" & Img (Z.Klient) & ": PILNE zamówienie "
               & Nazwa (Z) & " - " & Img (Z.Ilosc) & " szt. "
               & Nazwa (Z.Rodzaj), Czerwony);
            Magazynowanie.Magazyn.Zamowienie_Pilne (Z);
      end loop;

      Pisz ("Szpital S" & Img (Z.Klient) & " złożył wszystkie zamówienia");
   end Szpital;

   task body Apteka is
      G: Losowe.generator;
      Z: Zamowienie := (Prio=>Zwykly, others=> <>);
      begin
         accept Start (Nr: Positive) do
            Z.klient := Nr;
         end Start;
         
         Losowe.inicjuj (G, 300+Z.klient);

         for K in 1 .. zamowienia_szpitala loop
            delay Losowe.czas(G, 4.0, 10.0);
            Z.nr := K;
            Z.rodzaj := Losowe.losowy_towar(G);
            Z.ilosc := Losowe.liczba(G, 5, 15);
            Pisz ("Apteka A" & Img (Z.Klient) & ": ZWYKŁE zamówienie "
               & Nazwa (Z) & " - " & Img (Z.Ilosc) & " szt. "
               & Nazwa (Z.Rodzaj), Fioletowy);
            
            loop
               select
                  Magazynowanie.Magazyn.Zamowienie_Zwykle (Z);
                  exit;
               else
                  Pisz ("Apteka A" & Img (Z.Klient) & ": magazyn zajęty - "
                        & Nazwa (Z) & " odłożone na później", Szary);
                  delay Losowe.Czas (G, 1.0, 2.0);
               end select;
            end loop;

      end loop;

      Pisz ("Apteka A" & Img (Z.Klient) & " złożyła wszystkie zamówienia");
   end Apteka;

end Klienci;