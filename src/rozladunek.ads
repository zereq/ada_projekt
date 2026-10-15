with Typy; 
use Typy; 

package rozladunek is 

   task rampa is 

      entry zglos (D : dostawa);
      entry pobierz_partie (P : out partia; koniec : out Boolean);
      entry zamknij;
   
   end rampa;

end rozladunek;