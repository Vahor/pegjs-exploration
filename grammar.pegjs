arrow           = _ "->" _
_ "whitespace" = [ \t\n\r]*
any = .*
quotation_mark = '"'
unescaped = [^\0-\x1F\x22\x5C]
escape = "\\"
char = unescaped / escape sequence:(
		quotation_mark
		/ "\\"
		/ "/"
		/ "b" { return "\b"; }
		/ "f" { return "\f"; }
		/ "n" { return "\n"; }
		/ "r" { return "\r"; }
		/ "t" { return "\t"; }
  )
  { return sequence; }
object_start = _ "{" _
object_end = _ "}" _
array_start = _ "[" _
array_end = _ "]" _
value_separator = _ "," _
name_separator  = _ ":" _
new_branch = _ "->" _

number = [0-9]+

string = chars:char+ {
		return chars.join("");
}
quoted_string = quotation_mark value:string quotation_mark {
		return value;
}
false = "false" { return false; }
null  = "null"  { return null;  }
true  = "true"  { return true;  }

value "value"
		= string 
		/ quoted_string
		/ false
		/ true
		/ null


start
  = _ content:Content _ {
      return content;
    }

Content
  = companies:Companies 
  select:(Select)?
  fields:(ResultFields)? {
      return {
        companies: companies,
		select: select ?? [],
		fields: fields ?? []
      };
    }

Companies = "companies" object_start companies:Company+ object_end {
  return companies;
}

Company = key:quoted_string object_start body:(CompanyBody)+ object_end {
  return {
		_key: key,
		...body.reduce((acc, cur) => {
				Object.assign(acc, cur);
			return acc;
		}, {})
  };
}

CompanyBody 
		= _ value:(
		CompanyContext / CompanyKeywords
		) _  {
			return value;
		}

CompanyContext = "context" name_separator value:quoted_string {
  return {
    context: value
  };
}

CompanyKeywords = "keywords" name_separator array_start values:(
      head:quoted_string
      tail:(value_separator @quoted_string)*
      { return [head].concat(tail); }
    )? array_end {	
	return {
		keywords: values ?? []
	}
}

ResultFields = new_branch _ "fields" _ array_start fields:(
    head:ResultAllowedFields
    tail:(value_separator @ResultAllowedFields)*
    { return [head].concat(tail); }
  )? array_end {
	return fields ?? [];
}

ResultAllowedFields = "title" / "text" / "score" / "positive" / "negative"

Select = new_branch _ "select" object_start select:SelectBody+ object_end {
		return select;
}

SelectBody 
		= _ value:(
		SelectMethod
		) _  {
			return value;
		}

OrderBy = "ASC" / "DESC"
SelectTop = "top" "(" _ count:number _ ")" _ "by" _ field:ResultAllowedFields order:("." @OrderBy)? {
  return {
    method: "top",
    count: count,
	field: field,
	order: order ?? "ASC"
  };
}
SelectMethod = SelectTop
