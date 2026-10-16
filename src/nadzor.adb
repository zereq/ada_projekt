with Ada.Real_Time; use Ada.Real_Time;
with Ada.Strings.Wide_Wide_Unbounded; use Ada.Strings.Wide_Wide_Unbounded;
with Log; use Log;
with Magazynowanie; 

package body Nadzor is

   task body Monitor is
      Roboty: array (Id_Robota) of stany := (others => wolny);
      Dostawy: Natural := 0;
      Okres: constant Time_Span := To_Time_Span (Okres_Raportu);
      Nastepny: Time := Clock + Okres;

      procedure Drukuj (Tytul : Wide_Wide_String) is
         S: Stan_Magazynu;
         Tekst: Unbounded_Wide_Wide_String;

         procedure Linia (L : Wide_Wide_String) is
         begin
            Append (Tekst, L & NL);
         end Linia;

      begin
         Magazynowanie.Magazyn.Podaj_Stan (S);
         Linia ("--------- " & Tytul & " " & Czas & " ---------");
         Linia ("Magazyn: " & Img (S.Zapelnienie) & " / " & Img (Pojemnosc_Magazynu));

         for T in Towar loop
            Linia ("  " & Nazwa (T) & ": " & Img (S.Zapas (T)));
         end loop;

         for R in Id_Robota loop
            Linia ("Robot R" & Img (R) & ": " & Nazwa (Roboty (R)));
         end loop;

         Linia ("Dostawy obsłużone: " & Img (Dostawy) & " / " & Img (Liczba_Samochodow));

         for P in reverse Priorytet loop
            Linia ("Zamówienia " & Nazwa (P) & ": złożone "
                   & Img (S.Zlozone (P)) & ", zrealizowane "
                   & Img (S.Zrealizowane (P)) & ", oczekujące "
                   & Img (S.Oczekujace (P)) & ", odrzucone "
                   & Img (S.Odrzucone (P)));
         end loop;

         Append (Tekst, "---------------------------------------");

         Pisz_Blok (To_Wide_Wide_String (Tekst), Niebieski);
      end Drukuj;
      begin
         loop
            select
               accept Zglos_stan (R: Id_Robota; S: Stany) do
                  Roboty (R) := S;
               end Zglos_stan;
            or
               accept Dostawa_obsluzona do
                  Dostawy := Dostawy + 1;
               end Dostawa_obsluzona;
            or
               accept Koniec do
                  Drukuj ("Raport końcowy");
                  exit;
               end Koniec;
            or
               delay until Nastepny;
                  Drukuj ("Raport okresowy");
                  Nastepny := Nastepny + Okres;
            end select;
         end loop;
      end Monitor;

end Nadzor;