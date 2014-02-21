xquery version "1.0";
let $r :=
for $t in //word[@relation= ("PRED", "PRED_CO")]
let $o := $t/preceding-sibling::word[@relation = "OBJ"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head = $t/@id]
let $d := $t/parent::sentence/word[@relation="COORD"]
          [@head = $t/@id]
let $y := $t/preceding-sibling::word[@relation="OBJ_CO"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head = $d/@id]              
let $h := $t/following-sibling::word[@relation = "OBJ"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head = $t/@id]
let $z := $t/following-sibling::word[@relation="OBJ_CO"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head = $d/@id]
let $x := $t/parent::sentence/word[@relation= "COORD"]
          [@id = $t/@head]
let $a := $t/preceding-sibling::word[@relation = "OBJ"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head= $x/@id]          
let $s := $t/following-sibling::word[@relation = "OBJ"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head= $x/@id]          
let $j := $t/parent::sentence/word[@relation="COORD"]
          [@head = $x/@id]
let $b := $t/preceding-sibling::word[@relation = "OBJ_CO"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head= $j/@id]
let $c := $t/following-sibling::word[@relation = "OBJ_CO"]
          [@postag[matches(.,"(n|p)......a.")]]
          [@head= $j/@id]                                        
(: the following where clauses can be changed thus:
where $o or $y or $a or $b
where $h or $z or $s or $c
where ($o and $h) or ($o and $z) or ($o and $s) or ($o and $c) 
       or ($y and $h) or ($y and $z) or ($y and $s) or ($y and $c) 
       or ($a and $h) or ($a and $z) or ($a and $s) or ($a and $c)
       or ($b and $h) or ($b and $z) or ($b and $s) or ($b and $c) :)
where  $o or $y or $a or $b
return    <r cid="{$t/@cid}" v="{$t/@form}" cite="{$t/@cite}">
          <pre_object>{data($o/@form)}</pre_object>
          <passage>{data($o/parent::sentence/word/@form)}
          </passage>
          <pre_object_co>{data($y/@form)}</pre_object_co>
          <passage>{data($y/parent::sentence/word/@form)}
          </passage>
          <pre_obj_attached_to_coord>{data($a/@form)}</pre_obj_attached_to_coord>
          <passage>{data($a/parent::sentence/word/@form)}
          </passage>
          <pre_obj_co_attached_to_coord>{data($b/@form)}</pre_obj_co_attached_to_coord>
          <passage>{data($b/parent::sentence/word/@form)}
          </passage>
          <fol_object>{data($h/@form)}</fol_object>
          <passage>{data($h/parent::sentence/word/@form)}
          </passage>
          <fol_object_co>{data($z/@form)}</fol_object_co>
          <passage>{data($z/parent::sentence/word/@form)}
          </passage>
          <fol_obj_attached_to_coord>{data($s/@form)}</fol_obj_attached_to_coord>
          <passage>{data($s/parent::sentence/word/@form)}
          </passage>
          <fol_obj_co_attached_to_coord>{data($c/@form)}</fol_obj_co_attached_to_coord>
          <passage>{data($c/parent::sentence/word/@form)}
          </passage>          
          </r>
for $k at $n in $r
return <f number="{$n}">{$k}</f>