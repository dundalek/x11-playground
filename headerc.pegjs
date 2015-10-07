
start
  = nodes:(__ Node)* __ { return nodes.map(function(n) { return n[1]; }); }

Node
  = Preprocessor
  / Typedef

Typedef
  = __ 'typedef' __ def:(StructureDef / SimpleDef)  __ ';' { return def; }

Preprocessor
  = DefineDirective
  / GeneralDirective
  
DefineDirective
  = '#define' _ ident:Identifier _ value:NonLineTerminator* _ (LineTerminator / EOF) { return {
    type: 'Directive',
    directive: 'define',
    name: ident,
    value: value.join('')
  };}

GeneralDirective
  = '#' directive:[a-z]+ _ value:NonLineTerminator* _ (LineTerminator / EOF) { return {
    type: 'Directive',
    directive: directive.join(''),
    value: value.join('')
  };}

Identifier
  = [_A-Za-z] [_A-Za-z0-9]* { return text(); }

SimpleDef
  = idents:(__ Identifier)+ { return {
      type: 'TypedefDecl',
      name: idents[idents.length-1][1],
      value: idents.slice(0, -1).map(function(i) { return i[1]; })
    };}

StructureDef
  = __ 'struct' altName:(__ Identifier)? __ '{'
    fields:FieldDef+
    __ '}' __ name:Identifier? { return {
      type: 'RecordDecl',
      fields: fields,
      name: name,
      altName: altName && altName[1]
    };}

FieldDef
  = def:SimpleDef __ ';' { return def; }

__
  = (WhiteSpace / LineTerminatorSequence / Comment)*

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
