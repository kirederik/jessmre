package br.inf.ufpr.jessmre.classifier.main

import jess._

case class Classifier(topValue: Int, botValue: Int, desiredValue: Int) extends RuleSet {
  
  def this(t: Int, b:Int) {
    this(t, b, t-b)
  }
  
  def toMultiSlot(v: Integer) = {
    val ms = new ValueVector()
    for (c <- v.toString.toCharArray) {
      ms.add(new Value(c.asDigit, RU.INTEGER))
    }
    ms
  }
  
  lazy val top = {
    toMultiSlot(topValue)
  }
  
  lazy val bot = {
    toMultiSlot(botValue)
  }
  
  def subFact(engine: Rete) = {
    val subFact = new Fact("subtraction", engine)
    
    subFact.setSlotValue("top", new Value(top, RU.LIST))
    subFact.setSlotValue("bottom", new Value(bot, RU.LIST))
    subFact
  }
  
  def run(fileName: String, desired: Option[Int], src:String): Boolean = {
    val engine = new Rete();
    engine.batch(fileName)
    
    engine.assertFact(subFact(engine))
    engine.run()
    val it = engine.listFacts()
    
    while (it.hasNext) {
      val fact:Fact = it.next.asInstanceOf[Fact]
      if (fact.getName.endsWith("subtraction")) {
        val result = try {
          Some(fact.getSlotValue("result").toString.replace(" ", "").replace("_", "").toInt)
        } catch {
          case _: Throwable => None 
        }
        return result == desired
      }
    }
    false
  }
  
  def search(desired: Option[Int]): List[Rule] = {
    if (desired != None && (desired.get == desiredValue)) return List(new Rule("subtraction"))
    
    val r = for {
      category <- RULES
      rules <- for {
        subcategory <- category._2
        rules <- 
          for {
            rule <- subcategory._2
            if {
              run(packageName + category._1 + "/" + subcategory._1 + "/" + rule.src, desired, rule.src)
            }
          } yield rule
      } yield rules
    } yield rules
    
    r.toList
  }
}