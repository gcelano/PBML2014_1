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
