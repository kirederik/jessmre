package br.inf.ufpr.jessmre.classifier.mrefunctions

abstract class ComplementaryRoles extends MREFunction {}

case class DifferentProcess extends ComplementaryRoles {}
case class DifferentInformation extends ComplementaryRoles {}
