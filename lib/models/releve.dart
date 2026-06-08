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

  // consommation en m³
  double consommation() => indexCourant - indexPrecedent;

  // montant selon tarif
  double montantAPayer(double tarifM3) => consommation() * tarifM3;

  StatutPaiement get statut =>
      paye ? StatutPaiement.paye : StatutPaiement.nonPaye;
}