package Klienci is

   task type Szpital is
      entry Start (Nr: Positive);
   end Szpital;

      task type Apteka is
      entry Start (Nr: Positive);
   end Apteka;

end Klienci;