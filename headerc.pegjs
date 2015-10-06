
start
  = Header

Header
  = (__ Node)* __

Node
  = '!#endif' Preprocessor
  / Typedef
  / FieldDef
  
Typedef
  = __ 'typedef' __ (StructureDef / Identifier) __ Identifier? __ ';'

Preprocessor
  = PreIf
  / '#include' _ NonLineTerminator+ _ LineTerminator
  / '#' [a-z]+ _ Identifier _ NonLineTerminator* _ LineTerminator

PreIf
  = ('#ifdef' / '#ifndef') _ Identifier _ LineTerminator
    (Header LineTerminator '#else' _ LineTerminator)?
    Header LineTerminator '#endif' _ LineTerminator

IfKeyword
  = '#' ('else' 'elif' 'endif')

Identifier
  = [_A-Za-z] [_A-Za-z0-9]* {return text()}

StructureDef
  = __ 'struct' (__ Identifier?) __ '{'
    FieldDef+
    __ '}' 

FieldDef
  = __ Identifier (__ Identifier)+ __ ';'

__
  = (WhiteSpace / LineTerminatorSequence / Comment / Preprocessor)*

_
  = (WhiteSpace / MultiLineCommentNoLineTerminator)*

WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"
  / Zs

// Separator, Space
Zs = [\u0020\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000]

NonLineTerminator
  = !LineTerminator char:. {
      return char;
    }


LineTerminator
  = [\n\r\u2028\u2029]

LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

Comment "comment"
  = MultiLineComment
  / SingleLineComment

SourceCharacter
  = .

MultiLineComment
  = "/*" (!"*/" SourceCharacter)* "*/"

MultiLineCommentNoLineTerminator
  = "/*" (!("*/" / LineTerminator) SourceCharacter)* "*/"

SingleLineComment
  = "//" (!LineTerminator SourceCharacter)*

EOF
  = !.
