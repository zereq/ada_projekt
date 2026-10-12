package log is 

type kolor is (
   zwykly,
   szary,
   czerwony, 
   zielony, 
   zolty, 
   niebieski, 
   fioletowy, 
   cyjan);

NL : constant Wide_Wide_Character := Wide_Wide_Character'Val(10);

procedure pisz (
   Tekst : Wide_Wide_String;
   barwa : kolor := zwykly);

procedure pisz_blok ( 
   Tekst : Wide_Wide_String;
   barwa : kolor := zwykly);

function czas return Wide_Wide_String;

function Img (N : Integer) return Wide_Wide_String;

end log; 