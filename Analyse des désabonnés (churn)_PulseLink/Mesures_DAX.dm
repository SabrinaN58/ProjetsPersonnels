# MESURES DAX UTILISÉES

Dans ce projet d'analyse deux types de mesures DAX ont été utilisées pour analyser le churn des clients, les mesures implicites et explicites.
Ces mesures ont permis de construire des KPIs, la table de scoring et d'effectuer des comparaisons entre les clients actifs et désabonnés.

## ⚪ Les mesures implicites 

Les mesures implicites sont générées automatiquement dans Power BI et ont permis de réaliser les agrégations suivantes : 
- Le nombre de clients total
- La somme des revenus générés
- Moyenne des dépenses des appels longue distance
- Moyenne de consommation des données (Go)



## 🟣 Les mesures explicites

Les mesures explicites sont plus avancées car elles sont créées manuellement dans Power BI.

Ci-dessous quelques exemples : 

1. Moyenne des charges mensuelles

```DAX
MoyenneChargesMensuelles = 
 AVERAGE(UsageCharges[Monthly Charge Corrected])


 2. Moyenne des services souscrits

```DAX
 AVERAGEX(
    VALUES(CustomerService[Customer ID]),
        CALCULATE(DISTINCTCOUNT(
            CustomerService[Service Name]), 
            CustomerService[Subscribed] = "Yes"
        
        )
    )


3. Scores des clients à risque

```DAX
NiveauRisqueClient = 
VAR ScoreRisqueClient = SELECTEDVALUE(DimCustomer[ScoreRisqueCleint])
VAR NiveauxRisque =
SWITCH(
    TRUE(),
    ScoreRisqueClient <= 1, "🟢 Faible",
    ScoreRisqueClient = 2, "🟡 Moyen", "🔴 Élevé"
    )
RETURN
NiveauxRisque

