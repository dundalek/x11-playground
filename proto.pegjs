{
  function extractList(list, index) {
    var result = new Array(list.length), i;

    for (i = 0; i < list.length; i++) {
      result[i] = list[i][index];
    }

    return result;
  }

  function buildList(first, rest, index) {
    return [first].concat(extractList(rest, index));
  }
}

start = blanklines? nodes:node+ {return nodes; }

node
  = Header
  / CallDefinitionInformal
  / CallDefinitionFormal
  / EnumDefinition
  / TypeDefinition
  / Para

Header
  = ([A-Z] '.')? num:HeaderNumber c:line blanklines { return {
      t: 'Header',
      c: [
        num.length,
        [],
        c.trim()
      ]
    };}

HeaderNumber
  = first:[0-9]+ rest:('.' [0-9]+)* '.'? {return buildList(first, rest, 1); }

CallDefinitionInformal
  = '┌───' blanklinex
    _ name:TypeName description:Description blanklinex
    args:InformalTypeParam+
    CallParamSeparator
    returns:InformalTypeParam+
    '└───' blanklines? {return {
        t: 'CallInformal',
        name: name,
        description: description,
        args: args,
        returns: returns
      };}

CallDefinitionFormal
  = '┌───' blanklinex
    _ name:TypeName description:Description blanklinex
    args:TypeParam+
    CallParamSeparator
    returns:TypeParam+
    '└───' blanklines? {return {
        t: 'CallFormal',
        name: name,
        description: description,
        args: args,
        returns: returns
      };}

CallParamSeparator
  = _ '▶' blanklinex { return null; }

EnumDefinition
  = '┌───' blanklinex
    _ name:TypeName description:Description blanklinex
    params:EnumParam+
    '└───' blanklines? {return {
        t: 'Enum',
        name: name,
        description: description,
        params: params,
      };}

TypeDefinition
  = '┌───' blanklinex
    _ name:TypeName description:Description blanklinex
    params:TypeParam+
    '└───' blanklines? {return {
        t: 'Type',
        name: name,
        description: description,
        params: params
      };}
  
InformalTypeParam
  = _ name:TypeName _ ':' _ type:TypeName description:Description blanklinex {return {
      name: name,
      type: type,
      description: description
    }}

EnumParam
  = _ '0x' value:[0-9]+ _ type:TypeName _ description:Description blanklinex {return {
    value: parseInt(value.join(''), 16),
    name: type,
    description: description
  }}

TypeParam
  = (_ TypeName blanklinex)? _ length:NonBlank _ type:TypeName _ description:Description blanklinex {return {
    length: length,
    type: type,
    description: description
  }}

TypeName
  = [-A-Za-z0-9_]+ { return text(); }

Description
  = NonLineTerminator* { return text().trim(); }

Para "paragraph"
  = l:line+ blanklines { return {t: 'Para', c: l.join('')}; }

line = NonLineTerminator+ EOL { return text(); }

blanklinex
  = ((WhiteSpace / '❧')* LineTerminator)+

blanklines
  = ((WhiteSpace / '❧')* LineTerminator)+
  / EOF

EOL
  = LineTerminator
  / EOF
  
EOF
  = !.

_ = WhiteSpace*

NonBlank
  = (!WhiteSpace NonLineTerminator)+ { return text(); }

WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"

NonLineTerminator
  = !LineTerminator char:. {
      return char;
    }

LineTerminator "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"
