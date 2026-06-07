PROJECT : Application ASUFOR — Gestion des bornes-fontaines
Objectif : Permettre à une ASUFOR sénégalaise de suivre les relevés de compteur de ses bornes-fontaines et de calculer automatiquement la consommation et le montant à payer.
Étudiant : Cheikh Mouhamadou Habib Fall — DAR26 — ESMT
Deadline : 12 juin 2026
STACK : Flutter (Dart), stockage en mémoire (pas de base de données externe), navigation par routes nommées.
ÉCRANS : Écran 1 = liste des bornes. Écran 2 = détail d'une borne. Écran 3 = formulaire de relevé.
MODÈLE DE DONNÉES : Releve (borne: String, indexCourant: double, indexPrecedent: double, date: DateTime, paye: bool). Calculs : consommation = indexCourant - indexPrecedent. Montant = consommation × tarifM3.
TARIF : [à remplir avec le tarif réel que tu as trouvé] FCFA par m³.
FEATURES P0 (obligatoires) : Liste des bornes, détail d'une borne, formulaire d'ajout de relevé avec validation, suppression avec confirmation, calcul automatique consommation et montant, navigation par routes nommées avec passage d'arguments, écran À propos.
FEATURES P1 (bonus si temps) : Stockage avec shared_preferences, filtre payé/non payé, total des m³ consommés affiché.
CONVENTIONS : Dart en anglais pour les noms de variables, commentaires en français, un fichier par widget dans lib/widgets/, un fichier par écran dans lib/screens/, le modèle dans lib/models/.
GLOSSAIRE : Borne = une borne-fontaine identifiée par son nom. Relevé = une mesure du compteur à une date donnée. Index = le chiffre affiché sur le compteur en m³. Consommation = différence entre index courant et index précédent. ASUFOR = Association des Usagers du Forage, l'organisation villageoise qui gère l'eau.