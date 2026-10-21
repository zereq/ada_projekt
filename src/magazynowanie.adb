with Log; use Log;
with Losowe;

package body Magazynowanie is

   task body Magazyn is
      type Kolejka is array (1 .. Max_Oczekujacych) of Zamowienie;
      G: Losowe.generator;
      Zapas: Ilosc := (others => Zapas_Poczatkowy);
      Oczekujace: array (Priorytet) of Kolejka;
      Ile_Czeka: Liczniki := (others => 0);
      Zlozone: Liczniki := (others => 0);
      Zrealizowane: Liczniki := (others => 0);
      Odrzucone: Liczniki := (others => 0);
      Nowe: Zamowienie;
      Przyjety: Towar;
      Ile_Przyjeto: Natural;

      --  wylicza zapelnienie magazynu
      function Zapelnienie return Natural is
         Suma : Natural := 0;
      begin
         for T in Towar loop
            Suma := Suma + Zapas (T);
         end loop;
         return Suma;
      end Zapelnienie;

      function Opis_Zapelnienia return Wide_Wide_String is
         ("zapełnienie " & Img (Zapelnienie) & "/" & Img (Pojemnosc_Magazynu));

      -- obsluguje wydawanie zamowien
      procedure Wydaj (Z: Zamowienie) is
      begin
         Zapas (Z.Rodzaj) := Zapas (Z.Rodzaj) - Z.Ilosc;
         Zrealizowane (Z.Prio) := Zrealizowane (Z.Prio) + 1;
         delay Losowe.Czas (G, 0.2, 0.5);

         Pisz ("Zamówienie " & Nazwa (Z) & " (" & Nazwa (Z.Prio) & ") zrealizowane: "
            & Img (Z.Ilosc) & " szt. " & Nazwa (Z.Rodzaj) & " - "
            & Opis_Zapelnienia, Zielony);
      end Wydaj;

      -- funkcja pomocnicza ktora sprawdza czy ktos czeka na ten towar
      -- dla pilnych porownuje tylko z pilnymi, dla zwyklych z wszystkimi
      function Ktos_Czeka (Rodzaj : Towar; P : Priorytet) return Boolean is
      begin
         for Q in P .. Priorytet'Last loop
            for I in 1 .. Ile_Czeka (Q) loop
               if Oczekujace (Q) (I).Rodzaj = Rodzaj then
                  return True;
               end if;
            end loop;
         end loop;
         return False;
      end Ktos_Czeka;

      -- Modul A - obsluga zamowien
      -- przyjmuje lub odrzuca zamowienie w zaleznosci od stanu magazynu i kolejek oczekujacych
      procedure Obsluz (Z : Zamowienie) is
      begin
         Zlozone (Z.Prio) := Zlozone (Z.Prio) + 1;
         if Zapas (Z.Rodzaj) >= Z.Ilosc
           and then not Ktos_Czeka (Z.Rodzaj, Z.Prio)
         then
            Wydaj (Z);
         elsif Ile_Czeka (Z.Prio) < max_oczekujacych then
            Ile_Czeka (Z.Prio) := Ile_Czeka (Z.Prio) + 1;
            Oczekujace (Z.Prio) (Ile_Czeka (Z.Prio) ) := Z;
            if Zapas (Z.Rodzaj) >= Z.Ilosc then
               Pisz (Nazwa (Z) & " oczekuje - wcześniejsze zamówienia na "
                     & Nazwa (Z.Rodzaj) & " mają pierwszeństwo", Szary);
            else
               Pisz (Nazwa (Z) & " oczekuje - brak towaru " & Nazwa (Z.Rodzaj)
                     & " (jest " & Img (Zapas (Z.Rodzaj)) & ", potrzeba "
                     & Img (Z.Ilosc) & ")", Szary);
            end if;
         else
            Odrzucone (Z.Prio) := Odrzucone (Z.Prio) + 1;
            Pisz (Nazwa (Z) & " odrzucone - brak miejsca w kolejce oczekujących", Czerwony);
         end if;
      end Obsluz;

      -- Modul B - obsluguje kolejke wedlug priorytetu i wydaje zamowienia jesli jest to mozliwe
      procedure Realizuj_Oczekujace is
         Zablokowany : array (Towar) of Boolean := (others => False);
         I: Positive;
      begin
         for P in reverse Priorytet loop
            I := 1;
            while I <= Ile_Czeka (P) loop
               declare
                  Z : constant Zamowienie := Oczekujace (P) (I);
               begin
                  if not Zablokowany (Z.Rodzaj)
                    and then Zapas (Z.Rodzaj) >= Z.Ilosc
                  then
                     Oczekujace (P) (I .. Ile_Czeka (P) - 1) :=
                       Oczekujace (P) (I + 1 .. Ile_Czeka (P));
                     Ile_Czeka (P) := Ile_Czeka (P) - 1;
                     Wydaj (Z);
                  else
                     Zablokowany (Z.Rodzaj) := True;
                     I := I + 1;
                  end if;
               end;
            end loop;
         end loop;
      end Realizuj_Oczekujace;

   begin
      Losowe.inicjuj (G, 500);
      loop
         select
            when Zapelnienie <= Pojemnosc_Magazynu - Max_Parti =>
               accept Przyjmij (Rodzaj : Towar; Ilosc : Natural) do
                  Zapas (Rodzaj) := Zapas (Rodzaj) + Ilosc;
                  Przyjety := Rodzaj;
                  Ile_Przyjeto := Ilosc;
               end Przyjmij;
               Pisz ("Magazyn: przyjęto " & Img (Ile_Przyjeto) & " szt. "
                     & Nazwa (Przyjety) & ", " & Opis_Zapelnienia);
               Realizuj_Oczekujace;
         or
            accept Zamowienie_Pilne (Z : in Zamowienie) do
               Nowe := Z;
            end Zamowienie_Pilne;
            Obsluz (Nowe);
         or
            when Zamowienie_Pilne'Count = 0 =>
               accept Zamowienie_Zwykle (Z : in Zamowienie) do
                  Nowe := Z;
               end Zamowienie_Zwykle;
               Obsluz (Nowe);
         or
            accept Podaj_Stan (S : out Stan_Magazynu) do
               S := (Zapas        => Zapas,
                     Zapelnienie  => Zapelnienie,
                     Zlozone      => Zlozone,
                     Zrealizowane => Zrealizowane,
                     Oczekujace   => Ile_Czeka,
                     Odrzucone    => Odrzucone);
            end Podaj_Stan;
         or
            terminate;

         end select;
      end loop;

   end Magazyn;

end Magazynowanie;