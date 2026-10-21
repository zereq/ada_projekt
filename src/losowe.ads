with Ada.Numerics.Float_Random;
with typy;

package losowe is

   subtype generator is Ada.Numerics.Float_Random.generator;

   procedure inicjuj (G : in out generator; nr : Natural);

   function liczba (G : in out generator; min, max : Integer) return Integer;
   function czas (G : in out generator; min, max : Duration) return Duration;
   function losowy_towar (G : in out generator) return typy.towar;

end losowe;
