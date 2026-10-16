-- modul G
with Typy; use Typy;

package Nadzor is

   task Monitor is
      -- roboty i rampa zglaszaja zmiany stanu
      entry Zglos_Stan (Id : Id_Robota; Stan : stany);
      
      entry Dostawa_Obsluzona;
      
      entry Koniec; -- raport koncowy
   end Monitor;

end Nadzor;