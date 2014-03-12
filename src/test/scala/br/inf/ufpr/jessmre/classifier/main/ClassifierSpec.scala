package br.inf.ufpr.jessmre.classifier.main

import org.specs2.mutable._
import org.junit.runner.RunWith
import org.specs2.runner.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ClassifierSpec extends Specification {
  "The Classifier class".title
   
  val classifier = new Classifier(20, 15)
  
  "When given the correct answer" should {
    "respond with 'subtraction'" in {
      val searchResult = classifier.search(Some(5))
      searchResult.length mustEqual 1
      searchResult.apply(0).name mustEqual "subtraction"
    }
  }
  
  "if the problem is 20-15 ".txt
  
  "When given 15 as the answer, #search" should {
    "contains 'diff_0-n=n' rule" in {
     val searchResult = classifier.search(Some(15))
     searchResult must contain(new Rule("diff_0-n=n.clp"))
    }
  }
  "When given null as the answer, #search" should {
    "contains 'cant_subtract' rule" in {
      val searchResult = classifier.search(None)
      searchResult must contain(new Rule("cant_subtract.clp"))
    }
  }
}