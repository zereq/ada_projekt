with Dostawy;
with Klienci;
with Log; use Log;
with Nadzor;
with Rozladunek;
with Transport;
with Typy; use Typy;

procedure Ada_Project is
begin
   Pisz ("Start symulacji magazynu - Hurtownia farmaceutyczna", Niebieski);

   declare 
      Roboty: array (Id_robota) of Transport.Robot;
   begin
      for R in Roboty'Range loop
         Roboty (R).Start (R);
      end loop;

      declare
         Szpitale: array (1 .. Liczba_Szpitali) of Klienci.Szpital;
         Apteki: array (1 .. Liczba_Aptek) of Klienci.Apteka;
         Samochody: array (1 .. Liczba_Samochodow) of Dostawy.Samochod;
      begin
         for S in Szpitale'Range loop
            Szpitale (S).Start (S);
         end loop;

         for A in Apteki'Range loop
            Apteki (A).Start (A);
         end loop;

         for D in Samochody'Range loop
            Samochody (D).Start (D);
         end loop;
      end; -- czekamy na zakonczenie zadan samochodow i klientow

      Pisz ("Wszystkie dostawy rozładowane i zamówienia złożone - " & "zamykam rampę", Niebieski);
      Rozladunek.Rampa.Zamknij;
   end; -- czekamy az roboty wszystko rozwioza

   Nadzor.Monitor.Koniec;
   Pisz ("Koniec symulacji magazynu", Niebieski);
end Ada_Project;
