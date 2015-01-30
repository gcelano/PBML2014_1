(: The following code has been written by Giuseppe G. a. Celano. This is the initial query used to simplify sentences; an improved version follows it :)

<treebank>
{
(: this for clause is a technical expedient to put the words in the right order :)
for $r in

    (: captures PRED and PRED_CO because only main clauses receive the function PRED :)
    for $s in //word[@relation= ("PRED", "PRED_CO")]
    
    (: filters out subordinate conjunctions, participles, and conjunctions because we do not want them :) 
    let $r := $s/parent::sentence/word[@head = $s/@id][not(@relation="AuxC")][not(@postag[matches(., "t........")])][not(@relation="COORD")]
   
    (: looks for a coordinate conjunction so we can, for example, capture "and" in "I love Leipzig and Boston" :)
    let $u := $s/parent::sentence/word[@head = $s/@id][@relation="COORD"] 
    
    (: looks for non-verb and non-participle dependents of a verb which are coordinated, so we can, for example, capture "Leipzig" and "Boston" in "I love Leipzig and Boston"  :)
    let $i := $s/parent::sentence/word[@head = $u/@id][(@relation="OBJ_CO" or @relation="ADV_CO") and not(@postag[matches(., "t........")]) and not(@postag[matches(., "v........")])]     
    
    (: looks for prepositions, so we can, for example, capture "in" in "I live in Leipzig":)
    let $f := $s/parent::sentence/word[@head = $s/@id][@relation="AuxP"] 
   
    (: looks for dependents of prepositions which are not participles :)
    let $z := $s/parent::sentence/word[@head = $f/@id][not(@relation="AuxC")][not(@postag[matches(., "t........")])]
   
    (: looks for the dependents of the dependents of the main verb, as for example, "good" in "you did a good job" :)
    let $g := $s/parent::sentence/word[@head = $r/@id][@relation="ATR"][not(@postag[matches(., "v.......")])]
   
    (: looks for the dependents of the dependents of prepositions, as for example, "many" in "I deal with many students" :)
    let $a := $s/parent::sentence/word[@head = $z/@id][@relation="ATR"][not(@postag[matches(., "v.......")])]
    order by $s/parent::sentence/@subdoc, $s/parent::sentence/xs:integer(@id)   
    return
        <sentence document_id="{$s/parent::sentence/@document_id}" id="{$s/parent::sentence/@id}" subdoc="{$s/parent::sentence/@subdoc}">
        {$s, (if ($i) then ($i, $u[@id = $i/@head]) else ()), $r, $z, $g, $a}
        </sentence>
  return
   
    <sentence document_id="{$r/@document_id}" id="{$r/@id}" subdoc="{$r/@subdoc}">
    {
    for $t in $r/word
        order by $t/@id  
        return $t
    }
    </sentence>
}
</treebank>




(: The following query has been written by Giuseppe G. A. Celano. This is the final version used to simplify sentences :)

(: the function functx:is-node-in-sequence has been added by Maria Moriz :)
declare namespace functx = "http://www.functx.com";
declare function functx:is-node-in-sequence
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies $nodeInSeq is $node
 } ;
declare function functx:distinct-nodes
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence(
                                .,$nodes[position() < $seq]))]
 } ;

<treebank>
{
for $y in (: this for clause is a technical expedient to put the words in the right order :)
  for $s in //word[@relation= ("PRED", "PRED_CO")] (: captures PRED and PRED_CO because only main clauses receive the function PRED :)
    
    (: filters out subordinate conjunctions, participles, and conjunctions because we do not want them :)
    (: mod: also disallow punctuation, PRED_PA and verbs :)
    let $r := $s/parent::sentence/word[@head = $s/@id][not(@relation="PRED_PA")][not(@relation="AuxC")][not(@postag[matches(., "t........")])][not(@relation="COORD")][not(@postag[matches(., "u.......")])][not(@postag[matches(., "v.......")])]
   
    (: looks for a coordinate conjunction so we can, for example, capture "and" in "I love Leipzig and Boston" :)
    let $u := $s/parent::sentence/word[@head = $s/@id][@relation="COORD"] 
    
    (: looks for non-verb and non-participle dependents of a verb which are coordinated, so we can, for example, capture "L." and "B." in "I love L. and B."  :)
    (: mod: SBJ_CO of a COORD of a PRED_CO was added (s28); suggested by Barbara Pavlek :)
    let $i := $s/parent::sentence/word[@head = $u/@id][(@relation="OBJ_CO" or @relation="ADV_CO" or @relation="SBJ_CO") and not(@postag[matches(., "t........")]) and not(@postag[matches(., "v........")])]     
    
    (: looks for prepositions, so we can, for example, capture "in" in "I live in Leipzig":)
    let $f := $s/parent::sentence/word[@head = $s/@id][@relation="AuxP"] 
   
    (: looks for dependents of prepositions which are not participles :)
    let $z := $s/parent::sentence/word[@head = $f/@id][not(@relation="AuxC")][not(@postag[matches(., "t........")])]
   
    (: looks for the dependents of the dependents of the main verb, as for example, "good" in "you did a good job" :)
    let $g := $s/parent::sentence/word[@head = $r/@id][(@relation="ATR")][not(@postag[matches(., "v.......")])]
   
    (: looks for the dependents of the dependents of prepositions, as for example, "many" in "I deal with many students" :)
    (: mod: ADV_CO and OBJ_CO were allowed to capture coordinating adverbials (e.g. when children of a $z="and" are not just attributes s92) :)
    let $a := $s/parent::sentence/word[@head = $z/@id][(@relation="ATR" or @relation="ADV_CO" or @relation="OBJ_CO")][not(@postag[matches(., "v.......")])]

    (: mod: new variable: Sometimes attributes of coordinating objects ($i) are important (s19) :)
    let $t := $s/parent::sentence/word[@head = $i/@id][(@relation="ATR")]

    order by $s/parent::sentence/@subdoc, $s/parent::sentence/xs:integer(@id)   
    return
        <sentence document_id="{$s/parent::sentence/@document_id}" id="{$s/parent::sentence/@id}" subdoc="{$s/parent::sentence/@subdoc}">
        {
        let $all := ($s, (if ($i) then ($i, $u[@id = $i/@head]) else ()), $r, $z, $g, $a, $t)
        return if (count($all)>1) then functx:distinct-nodes($all) else ()
        }
        </sentence>
  return   (:concat(count($y/word), " &#10;"):)
   
    <sentence document_id="{$y/@document_id}" id="{$y/@id}" subdoc="{$y/@subdoc}">
    {
    (: the function functx:distinct-nodes() has been added by Maria Moriz :)
    for $x in functx:distinct-nodes($y/word)
        order by $x/@cid
        return $x, count($y/word)
    }
    </sentence>
}
</treebank>

