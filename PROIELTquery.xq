xquery version "1.0";
let $a :=
for $t in //token[@relation = "pred"][@form]
let $i := $t/parent::sentence/token
          [@part-of-speech = "G-"]
          [@id = $t/@head-id]
let $n := $t/parent::sentence/token[@relation = "pred"]
          [@part-of-speech= "C-"]
          [@id = $t/@head-id]
let $z := $t/parent::sentence/token
          [@part-of-speech = "G-"]
          [@id = $n/@head-id]
let $p := $t/parent::sentence/token[@relation= "obj"]
          [@part-of-speech = "C-"]
          [@head-id = $t/@id]
let $e := $t/preceding-sibling::token[@relation="obj"][@morphology[matches(., "......a...")]]
          [@part-of-speech = ("Pp", "Ne","Ps", "Pi","Pt", "Pk","Px", "Pc","Pd", "Nb")]
          [@head-id = $t/@id]
let $o := $t/preceding-sibling::token[@relation= "obj"][@morphology[matches(., "......a...")]]
          [@part-of-speech = ("Pp", "Ne","Ps", "Pi","Pt", "Pk","Px", "Pc","Pd", "Nb")]
          [@head-id = $p/@id]        
let $w := $t/following-sibling::token[@relation="obj"][@morphology[matches(., "......a...")]]
          [@part-of-speech = ("Pp", "Ne","Ps", "Pi","Pt", "Pk","Px", "Pc","Pd", "Nb")]
          [@head-id = $t/@id]
let $k := $t/following-sibling::token[@relation= "obj"][@morphology[matches(., "......a...")]]
          [@part-of-speech = ("Pp", "Ne","Ps", "Pi","Pt", "Pk","Px", "Pc","Pd", "Nb")]
          [@head-id = $p/@id]
(: the following two clauses serve to identify coordinate verbs sharing an object. 
Change the direction of the greater than sign in all the following clauses at the same time:  
> captures preverbal objects, while < captures postverbal objects :)
let $b := let $l := $t/parent::sentence/token[@relation = "pred"]
          [@head-id = $n/@id]/slash[@relation="obj"][@target-id= $e/@id]         
          where $l/parent::token/xs:integer(@id) > $e/xs:integer(@id) 
          return $l  
let $c := let $v := $t/parent::sentence/token[@relation = "pred"]
          [@head-id = $n/@id]/slash[@relation="obj"][@target-id= $p/@id]         
          where $v/parent::token/xs:integer(@id) > $o/xs:integer(@id)
          return $v                             
let $m := let $r := $t/parent::sentence/token[@relation = "pred"]
          [@head-id = $n/@id]/slash[@relation="obj"][@target-id= $w/@id]         
          where $r/parent::token/xs:integer(@id) > $w/xs:integer(@id)
          return $r  
let $f := let $y := $t/parent::sentence/token[@relation = "pred"]
          [@head-id = $n/@id]/slash[@relation="obj"][@target-id= $p/@id]         
          where $y/parent::token/xs:integer(@id) > $k/xs:integer(@id)
          return $y                            
(: the following where clause can be changed thus:   
where (not($i) and not($z)) and ($e or $o)   
where (not($i) and not($z)) and ($w or $k)   
where (not($i) and not($z)) and (($e and $w) or ($e and $k)
                                 or ($o and $w) or ($o and $k))
where (not($i) and not($z)) and ($b or $c or $m or $f)  :)  
where (not($i) and not($z)) and ($e or $o)                           
return    
<r id="{$t/@id}" locus="{$t/@citation-part}" v="{$t/@form}">          
<pre_object>{data($e/@form)}</pre_object>          
<passage>{data($e/parent::sentence/token/@form)}</passage>          
<pre_object_co>{data($o/@form)}</pre_object_co>
<passage>{data($o/parent::sentence/token/@form)}</passage>
<fol_object>{data($w/@form)}</fol_object>
<passage>{data($w/parent::sentence/token/@form)}</passage>
<fol_object_co>{data($k/@form)}</fol_object_co>
<passage>{data($k/parent::sentence/token/@form)}</passage>
<object_of_co_verb1  v="{$b/parent::token/@form}">{data($e/@form)}</object_of_co_verb1>
<passage>{data($b/parent::token/parent::sentence/token/@form)}</passage>
<object_of_co_verb2 v="{$c/parent::token/@form}">{data($o/@form)}</object_of_co_verb2>
<passage>{data($c/parent::token/parent::sentence/token/@form)}</passage>
<object_of_co_verb3  v="{$m/parent::token/@form}">{data($w/@form)}</object_of_co_verb3>
<passage>{data($m/parent::token/parent::sentence/token/@form)}</passage>
<object_of_co_verb4  v="{$f/parent::token/@form}">{data($k/@form)}</object_of_co_verb4>
<passage>{data($f/parent::token/parent::sentence/token/@form)}</passage>
</r>
for $m at $x in $a
return
<r number="{$x}">{$m}</r>