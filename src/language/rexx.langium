grammar Rexx

entry RexxProgram:
    (statements+=Statement)*;

Statement:
    Assignment ';'?
    | KeywordInstruction ';'?
    | Expression ';'?
    | Label
    | ';';

Label:
    name=ID ':';

Assignment:
    variable=Variable '=' expression=Expression;

Variable:
    {infer SimpleVariable} name=ID
    | {infer SpecialVariable} name='sigl'
    | {infer CompoundVariable} stem=ID '.' tail=(ID | STRING | NUMBER);

Expression:
    OrExpression;

OrExpression:
    AndExpression ({infer BinaryExpression.left=current} operator='|' right=AndExpression)*;

AndExpression:
    ComparisonExpression ({infer BinaryExpression.left=current} operator='&' right=ComparisonExpression)*;

ComparisonExpression:
    ConcatenationExpression ({infer BinaryExpression.left=current} operator=ComparisonOperator right=ConcatenationExpression)*;

ComparisonOperator returns string:
    '=' | '==' | '<>' | '><' | '>' | '<' | '>=' | '<=' 
    | '>>' | '<<' | '>>=' | '<<=';

ConcatenationExpression:
    AdditionExpression ({infer BinaryExpression.left=current} operator='||' right=AdditionExpression)*;

AdditionExpression:
    MultiplicationExpression ({infer BinaryExpression.left=current} operator=('+' | '-') right=MultiplicationExpression)*;

MultiplicationExpression:
    PowerExpression ({infer BinaryExpression.left=current} operator=('*' | '/' | '%' | '//') right=PowerExpression)*;

PowerExpression:
    PrefixExpression ({infer BinaryExpression.left=current} operator='**' right=PrefixExpression)*;

PrefixExpression:
    {infer UnaryExpression} operator=('-' | '+') operand=PrimaryExpression
    | PrimaryExpression;

PrimaryExpression:
    {infer LiteralExpression} value=STRING
    | {infer HexLiteralExpression} value=HEX_STRING
    | {infer BinLiteralExpression} value=BIN_STRING
    | {infer HexStringWithTextExpression} hexValue=HEX_STRING textValue=STRING
    | {infer BinStringWithTextExpression} binValue=BIN_STRING textValue=STRING
    | {infer NumberExpression} value=NUMBER
    | {infer ConstantExpression} value=CONST_SYMBOL
    | {infer VariableExpression} variable=Variable
    | {infer ParenthesisExpression} '(' expression=Expression ')'
    | {infer FunctionCallExpression} name=ID ('(' (arguments+=Expression (',' arguments+=Expression)*)? ')')?;

KeywordInstruction:
    SayInstruction
    | IfInstruction
    | DoInstruction
    | ReturnInstruction
    | ParseInstruction
    | LeaveInstruction
    | SignalInstruction
    | ExitInstruction;

SayInstruction:
    'say' expression=Expression?;

IfInstruction:
    'if' condition=Expression 'then' thenPart=Statement ('else' elsePart=Statement)?;

DoInstruction:
    'do' 
       (assignment=Assignment)? 
       (count=Expression)? 
       ('while' whileExpr=Expression | 'until' untilExpr=Expression)? 
       bodyStatements+=Statement* 
       'end';

ReturnInstruction:
    'return' (expression=Expression)?;

ParseInstruction:
    'parse' ('upper')? parseType=ParseType templateList=TemplateList?;

ParseType:
    {infer ParseKeyword} value=('arg' | 'external' | 'numeric' | 'pull' | 'source' | 'version')
    | {infer ParseValueWith} 'value' expression=Expression? 'with'
    | {infer ParseVar} 'var' variable=ID;

TemplateList:
    items+=TemplateItem (',' items+=TemplateItem)*;

TemplateItem:
    {infer TemplateVariable} variable=ID
    | {infer TemplatePeriod} value='.'
    | {infer TemplateString} value=STRING
    | {infer TemplateNumber} value=NUMBER;

LeaveInstruction:
    'leave' label=ID?;

SignalInstruction:
    'signal' ('on' | 'off')? target=Expression?;

ExitInstruction:
    'exit' expression=Expression?;

terminal ID: /[_!?a-zA-Z][_!?a-zA-Z0-9]*/;
terminal CONST_SYMBOL: /[0-9]+[_!?a-zA-Z][_!?a-zA-Z0-9]*/;
terminal NUMBER: /[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?/;
terminal STRING: /"[^"]*"|'[^']*'/;
terminal HEX_STRING: /[xX]'[0-9A-Fa-f]+'|"[0-9A-Fa-f]+"[xX]/;
terminal BIN_STRING: /[bB]'[01]+'|"[01]+"[bB]/;

hidden terminal WS: /[\t\f\r\n ]+|,[ \t]*((\/\*[\s\S]*?\*\/)|\/\/[^\n\r]*)?[ \t]*[\r\n][ \t]*/;
hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;
