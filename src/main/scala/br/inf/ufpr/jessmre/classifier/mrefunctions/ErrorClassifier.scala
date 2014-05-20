package br.inf.ufpr.jessmre.classifier.mrefunctions

import br.inf.ufpr.jessmre.classifier.main._


case class Error(
    errorType: String,
    subClassification: Option[String],
    mreFunction: MREFunction
) {

}

trait ErrorByRule {
  val wrong_interpretation = new Error("Interpretação Equivocada", None, new DifferentInformation())
  val directIdentify = Map(
      "domain" -> new Error(
          "Diretamente Identificável", 
          Some("Deficiência do domínio"), 
          new Familiriality()
      ), 
      "rule" -> new Error(
          "Diretamente Identificável", 
          Some("Deficiência de regra"), 
          new Abstraction()
      ),
      "operator" -> new Error(
          "Diretamente Identificável",
          Some("Deficiência na escolha do operador"),
          new InherentProperties()
      )
  )
  val indirectIdentify = new Error("Indiretamente Identificável", None, new Familiriality())
  val notAcceptable = new Error("Solução não aceitável", None, new Abstraction())
 
  val ERRORS = Map(
    "incorrectfetch" -> Map(
        "borrowfromzero" -> directIdentify.get("domain").get
        , "noadjacent" -> wrong_interpretation
        , "noborrowoverblanks" -> directIdentify.get("domain").get
        , "twocolumn" -> directIdentify.get("domain").get
    ),
    "missingrule" -> Map(
        "deletionborrowing" -> directIdentify.get("rule").get
        , "deletionborrowzero" -> directIdentify.get("rule").get
    ),
    "missingsubprocedure" -> Map(
        "multiplezeros" -> directIdentify.get("domain").get
        , "noborrow" ->  directIdentify.get("rule").get
        , "noborrowfromzero" -> directIdentify.get("rule").get
        , "nopartialcolumns" ->  directIdentify.get("domain").get
    ), 
    "testpattern" -> Map(
        "borrowonce" -> indirectIdentify
        , "noadjacentborrow" -> indirectIdentify
        , "overgeneralization" -> indirectIdentify
    ),
    "topzero" -> Map(
        "notafterborrow" -> indirectIdentify
        , "topzero" -> wrong_interpretation
        , "topzeroafterborrow" -> indirectIdentify
    ),
    "misc" -> Map("all" -> notAcceptable)
  )
  
}

case class ErrorClassifier() extends ErrorByRule {
  
  def classify(category: String, subcategory: String): Error = {
    ERRORS.get(category).get.get(subcategory).get
  }
  
  def classify(rules: List[CompleteRule]): List[Error] = {
    for {
      rule <- rules
      error <- ERRORS.get(rule.category).get.get(rule.subCategory)
    } yield error
  }
  
}
