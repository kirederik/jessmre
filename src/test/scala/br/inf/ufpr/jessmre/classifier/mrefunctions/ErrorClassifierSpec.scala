package br.inf.ufpr.jessmre.classifier.mrefunctions

import org.specs2.mutable._
import org.junit.runner.RunWith
import org.specs2.runner.JUnitRunner
import br.inf.ufpr.jessmre.classifier.main._

@RunWith(classOf[JUnitRunner])
class ErrorClassifierSpec extends Specification {
  "The ErrorClassifier class".title
  
  val errorclassifier = new ErrorClassifier()
  
  "When given a category and a subcategory" should {
    "respond with the correct Error object" in {
      errorclassifier.classify("testpattern", "noadjacentborrow") mustEqual
        new Error("Indiretamente Identificável", None, new Familiriality())
    }
  }
  
  val classifier = new Classifier(20, 15)
  val ruleList = classifier.search(Some(15))
  
  "When given a rule list" should {
    "respond with a error list" in {
      errorclassifier.classify(ruleList) must contain(
         new Error("Indiretamente Identificável", None, new Familiriality())
      )
    }
  }
  
}