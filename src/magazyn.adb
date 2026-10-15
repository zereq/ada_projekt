with Log; use Log;
with Typy; use Typy;

package body Magazyn is 

    task body serwer is
        stan : stan_magazynu;
        dziala : Boolean := True;
    begin
        --Init stanu poczatkowego
        for T in Towar loop
            stan.zapas(T) := typy.zapas_poczatkowy;
            stan.zapelnienie := stan.zapelnienie + zapas_poczatkowy;
        end loop;

        pisz ("magazyn: uruchomiony. Zapelnienie poczatkowe: " & Img(stan.zapelnienie) & "/" & Img(pojemnosc_magazynu), zielony);

        while dziala loop
            select 
                --wpusc robota z dostawa tylko gdy zmiesci sie max mozliwa partia
                when stan.zapelnienie + max_parti <= pojemnosc_magazynu => 
                    accept przyjmij (P : in partia) do
                        --zwiekszenie zapasu konkrentego leku
                        stan.zapas(P.rodzaj) := stan.zapas(P.rodzaj) + P.ilosc;
                        --zwiekszenie ogolnego stanu
                        stan.zapelnienie := stan.zapelnienie + P.ilosc;

                        pisz ("magazyn: przyjęto " & Img(P.ilosc) & " szt. (" & Nazwa(P.rodzaj) & ") z D" & Img(P.id_dostawy) & " | Stan: " & Img(stan.zapelnienie) & "/" & Img(pojemnosc_magazynu), zielony);
                        end przyjmij;
            or  
                --wydawanie zamowien 
                accept pobierz_towar (T : in Towar; Ile : in Positive; Sukces : out Boolean) do
                    if stan.zapas(T) >= Ile then 
                        stan.zapas(T) := stan.zapas(T) - Ile;
                        stan.zapelnienie := stan.zapelnienie - Ile;
                        Sukces := True;
                        pisz ("magazyn: wydano " & Img(Ile) & " szt. (" & Nazwa(T) &") | Stan: " & Img(stan.zapelnienie) & "/" & Img(pojemnosc_magazynu), zielony);
                    else
                        Sukces := False;
                        pisz ("magazyn: zabraklo " & Nazwa(T) & " aby zrealizować zamowienie");
                    end if;
                end pobierz_towar;

            or  
                --przekazanie stanu magazynu
                accept pobierz_stan (Stan_Out : out stan_magazynu) do
                    Stan_out := stan;
                end pobierz_stan;
            
            or 
                --zamkniecie magazynu
                accept zamknij do
                    dziala := False;
                    pisz ("magazyn: zamkniety", czerwony);
                end zamknij;
            
            or
                terminate; 
            
            end select;
        end loop;
   end serwer;
end Magazyn;



                    

                



            
        
