# Les ensembles
set USINES ;
set DEPOTS ;
set CLIENTS ;
set ensemble:= USINES union DEPOTS union CLIENTS ;
set ROUTES within (ensemble cross ensemble) ;
##### Pour le graphe des routes #####
param xpos {ensemble} ;
param ypos {ensemble} ;
#####################################
# Les
param
param
param
param
parametres
cout_unitaire{ROUTES} ; # Les couts unitaires de la distribution
cap_usines{USINES}>=0 ; # La capacite de la production de l’usine
cap_depots{DEPOTS}>=0 ; # Debit mensuel de depot
dem_client{CLIENTS}>=0 ; # La demende mensuel de client
# Les variables
var quantite_transportee{ROUTES}>=0 ; # La quantite transporte du depart
i a l’arrive j
# Objectif
minimize cout : sum{(i,j)in ROUTES}
cout_unitaire[i,j]*quantite_transportee[i,j] ;
# Les contraintes
subject to cap_max_usine{u in USINES} : # La capacite maximale de la
production des usines
sum{(u,r) in ROUTES} quantite_transportee[u,r]<=cap_usines[u] ;
subject to cap_max_depot{d in DEPOTS} :
sum{(u,d) in ROUTES} quantite_transportee[u,d]<=cap_depots[d] ;
subject to demande_clients {c in CLIENTS} : # Les besoins des clients
sum{(r,c) in ROUTES} quantite_transportee[r,c]=dem_client[c] ;
# On veut pas stocker la marchandise dans les depots, donc la quantite
entree au dpots devrait sortir totalement
subject to equilibre_Depots{d in DEPOTS} :
sum{(u,d) in ROUTES} quantite_transportee[u,d]=sum{(d,c) in ROUTES}
quantite_transportee[d,c] ;
