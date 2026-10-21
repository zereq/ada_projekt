with log;
use log;
with losowe;
with rozladunek; 
with typy; 
use typy;

package body dostawy is 


   task body samochod is 
      G : losowe.generator;
      D : dostawa; 

   begin 
      accept start (nr : Positive) do 
         D.id := nr; 
      end start;
      losowe.inicjuj (G, D.id);
      D.rodzaj := losowe.losowy_towar (G);
      D.ilosc := losowe.liczba (G, min_dostawy, max_dostawy);

      delay Duration (4 * (D.id - 1)) * Tempo + losowe.czas (G, 0.0, 3.0);

      pisz ("przyjazd samochodu dostaw" & Img (D.id) & " (" & Nazwa (D.Rodzaj) & ", " & Img (D.ilosc) & " szt.)", zolty);
      pisz("D" & Img (D.id) & " oczekuje na rozladunek");
      rozladunek.rampa.zglos (D);
      pisz ("D" & Img (D.id) & " odjezdza z centrum");
   
   end samochod;

end dostawy;