with Log; use Log;

package body Typy is
   function Nazwa (T : Towar) return Wide_Wide_String is
      (case  T is
         when szczepionki => "szczepionki",
         when antybiotyki => "antybiotyki",
         when opatrunki => "opatrunki");

   function Nazwa (P : Priorytet) return Wide_Wide_String is
      (case P is
         when zwykly => "zwykłe",
         when pilne => "pilne");

   function Nazwa (S : Stany) return Wide_Wide_String is
      (case S is
         when wolny => "wolny",
         when jedzie => "jedzie do magazynu",
         when czeka => "czeka na miejsce w magazynie",
         when wraca => "wraca na rampę",
         when wylaczony => "wyłączony");

   function Nazwa (Z : zamowienie) return Wide_Wide_String is
      ((if Z.prio = pilne
      then "S" else "A")
      & Img (Z.klient) & "-" & Img (Z.nr));

end Typy;
