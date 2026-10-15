--  MODUŁ 3 + A + B: magazyn leków realizujący zamówienia klientów
with Typy; use Typy;

package Magazynowanie is

   task Magazyn is
      --  gdy robot przynosi partie towarow
      entry Przyjmij (Rodzaj : Towar; Ilosc : Natural);

      --  zamowienia pilne (szpitale) i zwykle (apteki)
      entry Zamowienie_Pilne (Z : Zamowienie);
      entry Zamowienie_Zwykle (Z : Zamowienie);

      --  gdy monitor pyta o stan
      entry Podaj_Stan (S : out Stan_Magazynu);
   end Magazyn;

end Magazynowanie;
