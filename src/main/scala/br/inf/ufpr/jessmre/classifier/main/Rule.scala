package br.inf.ufpr.jessmre.classifier.main

case class Rule(name: String, src: String) {
  def this(src: String) {
    this(src.replaceFirst(".clp", ""), src)
  }
}

case class CompleteRule(rule: Rule, category: String, subCategory: String)