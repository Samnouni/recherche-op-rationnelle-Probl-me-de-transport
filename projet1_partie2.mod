# Les ensembles
set USINES ;
set DEPOTS ;
set CLIENTS ;
set ensemble:= USINES union DEPOTS union CLIENTS ;
set ROUTES within (ensemble cross ensemble) ;
# Les parametres
param nouvelle_cap_Depots {DEPOTS} ;# Augmentation ou diminuation de la
capacite
param finances_economies {DEPOTS} ; # les couts et les benifices pour les
changements
param cout_unitaire{ROUTES} ;
# Les couts unitaires de la distribution
param cap_usines{USINES}>=0 ;
# La capacit de la production de l’usine
param cap_depots{DEPOTS}>=0 ;
# Debit mensuel de depot
param dem_client{CLIENTS}>=0 ; # La demende mensuel de client
# Les variables
var quantite_transportee{ROUTES}>=0 ; # La quantite transporte du dpart i
l’arriv j
var decision{DEPOTS} >=0 , binary ; # La variable decisionnelle
(inchangeable,fermeture,agrandir)
# Objectif
minimize cout : sum{(i,j)in ROUTES}
cout_unitaire[i,j]*quantite_transportee[i,j]+ sum{d in DEPOTS}
decision[d]*finances_economies[d]
# Les contraintes
subject to cap_max_usine{u in USINES} : # La capacite maximale de la
production des usines
sum{(u,r) in ROUTES} quantite_transportee[u,r]<=cap_usines[u]
subject to cap_max_depot{d in DEPOTS} : # La capacite maximale des depots
au cas inchangeable ou fermeture
sum{(u,d) in ROUTES}
quantite_transportee[u,d]<=cap_depots[d]+decision[d]*nouvelle_cap_Depots[d]
;
subject to demande_clients {c in CLIENTS} : # Les besoins des clients
sum{(r,c) in ROUTES} quantite_transportee[r,c]=dem_client[c] ;
# On veut pas stocker la marchandise dans les depots, donc la quantite
entree au depots devrait sortir totalement
subject to equilibre_Depots{d in DEPOTS} :
sum{(u,d) in ROUTES} quantite_transportee[u,d]=sum{(d,c) in ROUTES}
quantite_transportee[d,c] ;
## On veut preds au plus 4 decisions ##
subject to Decisions :
sum {d in DEPOTS} decision[d] - decision["Lon"] <= 4 ;
