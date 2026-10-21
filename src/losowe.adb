with Ada.Calendar;

package body losowe is

   package FR renames Ada.Numerics.Float_Random;

   procedure inicjuj (G : in out generator; Nr : Natural) is
      teraz : constant Float := Float (Ada.Calendar.Seconds (Ada.Calendar.Clock));
   begin
      FR.reset (G, Integer (teraz * 100.0) + Nr * 7919);
   end inicjuj;

   function liczba (G : in out generator; min, max : Integer) return Integer is
      wynik : constant Integer := min + Integer (Float'Floor (FR.Random (G) * Float (max - min + 1)));
   begin
      return Integer'min (wynik, max);
   end liczba;

   function czas (G : in out generator; min, max : Duration) return Duration is
   begin
      -- mnozymy przez stala tempo, zeby spowolnic wyswietlanie do odczytu
      return min + Duration (Float (max - min) * FR.Random (G)) * Typy.Tempo;
   end czas;

   function losowy_towar (G : in out generator) return typy.towar is
   begin
      return typy.towar'Val
         (liczba (G, 0, typy.towar'Pos (typy.towar'Last)));
   end losowy_towar;

end losowe;
