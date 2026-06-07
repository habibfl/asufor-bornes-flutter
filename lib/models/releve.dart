// Modèle de données pour un relevé de compteur de borne-fontaine

enum StatutPaiement { paye, nonPaye }

class Releve {
  final String borne;
  final double indexCourant;
  final double indexPrecedent;
  final DateTime date;
  bool paye;

  Releve({
    required this.borne,
    required this.indexCourant,
    required this.indexPrecedent,
    required this.date,
    this.paye = false,
  });

  // Calcule la consommation en m³
  double consommation() {
    return indexCourant - indexPrecedent;
  }

  // Calcule le montant à payer selon le tarif au m³
  double montantAPayer(double tarifM3) {
    return consommation() * tarifM3;
  }

  // Retourne le statut sous forme d'enum
  StatutPaiement get statut =>
      paye ? StatutPaiement.paye : StatutPaiement.nonPaye;
}