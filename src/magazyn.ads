with Typy; use Typy;

package Magazyn is

    task serwer is 
        entry przyjmij (P : in partia);
        entry pobierz_towar (T : in Towar; Ile : in Positive; Sukces : out Boolean);
        entry pobierz_stan (Stan_Out : out stan_magazynu);
        entry zamknij;
    end serwer;

end Magazyn;