struct DecisionResult {
    var isEligibleIV: Bool
    var isEligibleEndovascular: Bool
    var exclusionReasons: [String]
}

struct PatientDataModel {
    var timeSinceOnsetHours: Double
    var systolicBP: Double
    var diastolicBP: Double
    var glucose: Double
    var platelets: Int
    var nihssScore: Int
    var age: Int
    var rankinPrevia: Int
    var bpControlled: Bool
    var onHBP: Bool
    var onHeparin: Bool
    var ttpProlonged: Bool
    var onACO: Bool
    var acoType: String
    var hoursSinceLastDose: Double
    var inr: Double
}

func evaluateIctusEligibility(from patient: PatientDataModel) -> DecisionResult {
    let timeSinceOnsetHours = patient.timeSinceOnsetHours
    let systolicBP = patient.systolicBP
    let diastolicBP = patient.diastolicBP
    let glucose = patient.glucose
    let platelets = patient.platelets
    let nihssScore = patient.nihssScore
    let age = patient.age
    let rankinPrevia = patient.rankinPrevia
    let bpControlled = patient.bpControlled
    let onHBP = patient.onHBP
    let onHeparin = patient.onHeparin
    let ttpProlonged = patient.ttpProlonged
    let onACO = patient.onACO
    let acoType = patient.acoType
    let hoursSinceLastDose = patient.hoursSinceLastDose
    let inr = patient.inr

    var exclusions: [String] = []

    if timeSinceOnsetHours > 24 {
        exclusions.append("Tiempo de evolución > 24h: excluido de código ictus")
    }

    if (systolicBP > 185 || diastolicBP > 105) && !bpControlled {
        exclusions.append("TA > 185/105 no controlable: contraindicación")
    }

    if glucose < 50 || glucose > 400 {
        exclusions.append("Glucemia < 50 o > 400 mg/dL: contraindicación")
    }

    if platelets < 50_000 {
        exclusions.append("Plaquetas < 50.000/μL: contraindicación para tratamiento endovascular")
    }
    if platelets < 100_000 {
        exclusions.append("Plaquetas < 100.000/μL: contraindicación para trombólisis IV")
    }

    if onHBP {
        exclusions.append("HBP a dosis terapéuticas en últimas 24h: contraindicación")
    }

    if onHeparin && ttpProlonged {
        exclusions.append("Heparina no fraccionada con TTPA prolongado: contraindicación")
    }

    if onACO {
        if acoType == "AVK" && inr > 1.7 {
            exclusions.append("ACO tipo AVK con INR > 1.7: contraindicación")
        }
        if acoType == "NACO" {
            if hoursSinceLastDose < 12 {
                exclusions.append("NACO tomado <12h: contraindicación")
            } else if hoursSinceLastDose < 48 {
                exclusions.append("NACO tomado hace 12–48h: valorar tratamiento endovascular")
            }
        }
    }

    if nihssScore < 4 {
        exclusions.append("NIHSS < 4: No indicado tratamiento trombolítico")
    }

    let eligibleIV = exclusions.isEmpty && timeSinceOnsetHours <= 4.5 && nihssScore >= 4
    let eligibleEndovascular = exclusions.isEmpty && timeSinceOnsetHours <= 24 && nihssScore >= 6 && age >= 18 && rankinPrevia <= 1

    return DecisionResult(isEligibleIV: eligibleIV, isEligibleEndovascular: eligibleEndovascular, exclusionReasons: exclusions)
}
