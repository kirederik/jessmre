package br.inf.ufpr.jessmre.classifier.mrefunctions

abstract class DeeperUnderstanding extends MREFunction{}


case class Abstraction extends DeeperUnderstanding{}
case class Relation extends DeeperUnderstanding{} 
case class Extension extends DeeperUnderstanding{}