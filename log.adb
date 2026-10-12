with Ada.Real_Time; use Ada.Real_Time;
with Ada.Strings.Wide_Wide_Fixed;
with Ada.Wide_Wide_Text_IO;

package body Log is 

Start: constant Time := Clock; 

ESC : constant Wide_Wide_Character := Wide_Wide_Character'Val (27);


task konsola is 
   entry wypisz (Linia: Wide_Wide_String);
end konsola;

task body konsola is 
begin
   loop
      select
         accept wypisz (linia : Wide_Wide_String) do 
            Ada.Wide_Wide_Text_IO.Put_line (linia);
         end wypisz;
      or 
         terminate;
      end select;
   end loop;
end konsola;

function kod (barwa : kolor ) return Wide_Wide_String is
   (case barwa is 
      when zwykly => "0",
      when szary => "90",
      when czerwony => "91",
      when zielony => "92",
      when zolty => "93",
      when niebieski => "94",
      when fioletowy => "95",
      when cyjan => "96");

function pokoloruj 
   (Tekst : Wide_Wide_String; barwa : kolor) return Wide_Wide_String is 
   (if barwa = zwykly then Tekst
   else ESC & "[" & kod (barwa) & "m" & tekst & ESC & "[0m");

function Img (n: Integer) return Wide_Wide_String is 
begin
   return Ada.Strings.Wide_Wide_Fixed.Trim
      (Integer'Wide_Wide_Image (N), Ada.Strings.Left);
   end Img;

function czas return Wide_Wide_String is 
   dziesiate : constant Natural := 
      Natural (Float (To_Duration (Clock - Start))* 10.0);
   sekundy : constant Natural := Dziesiate / 10; 
begin 
   return "["
      & (if sekundy < 10 then "0" else "") & Img (sekundy) & "." & Img (dziesiate mod 10) & "]";
end czas;

procedure pisz (tekst : Wide_Wide_String; barwa : kolor) is 
begin
   konsola.wypisz (czas & " " & pokoloruj (Tekst, barwa));
end pisz; 

procedure pisz_blok (Tekst : Wide_Wide_String; barwa : kolor) is
begin
   konsola.wypisz (pokoloruj (Tekst, barwa));
end pisz_blok; 

end log;
