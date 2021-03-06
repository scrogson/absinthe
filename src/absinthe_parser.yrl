Nonterminals
  Document
  Definitions Definition OperationDefinition Fragment TypeDefinition
  ObjectDefinition InterfaceDefinition UnionTypeDefinition
  ScalarTypeDefinition EnumTypeDefinition InputObjectDefinition TypeExtensionDefinition
  FieldDefinitionList FieldDefinition ImplementsInterfaces ArgumentsDefinition
  InputValueDefinitionList InputValueDefinition UnionMembers
  EnumValueDefinitionList EnumValueDefinition
  SelectionSet Selections Selection
  OperationType Name NameWithoutOn VariableDefinitions VariableDefinition Directives Directive
  Field Alias Arguments ArgumentList Argument
  FragmentSpread FragmentName InlineFragment
  VariableDefinitionList Variable DefaultValue
  Type TypeCondition NamedTypeList NamedType ListType NonNullType
  Value EnumValue ListValue Values ObjectValue ObjectFields ObjectField.

Terminals
  '{' '}' '(' ')' '[' ']' '!' ':' '@' '$' '=' '|' '...'
  'query' 'mutation' 'subscription' 'fragment' 'on' 'null'
  'type' 'implements' 'interface' 'union' 'scalar' 'enum' 'input' 'extend'
  name int_value float_value string_value boolean_value.

Rootsymbol Document.

Document -> Definitions : build_ast_node('Document', #{'definitions' => '$1'}, #{'start_line' => extract_line('$1')}).

Definitions -> Definition : ['$1'].
Definitions -> Definition Definitions : ['$1'|'$2'].

Definition -> OperationDefinition : '$1'.
Definition -> Fragment : '$1'.
Definition -> TypeDefinition : '$1'.

OperationType -> 'query' : extract_atom('$1').
OperationType -> 'mutation' : extract_atom('$1').
OperationType -> 'subscription' : extract_atom('$1').

OperationDefinition -> SelectionSet : build_ast_node('OperationDefinition', #{'operation' => 'query', 'selection_set' => '$1'}, #{'start_line' => extract_child_line('$1')}).
OperationDefinition -> OperationType SelectionSet : build_ast_node('OperationDefinition', #{'operation' => '$1', 'selection_set' => '$2'}, #{'start_line' => extract_line('$2')}).
OperationDefinition -> OperationType Name SelectionSet : build_ast_node('OperationDefinition', #{'operation' => '$1', 'name' => extract_binary('$2'), 'selection_set' => '$3'}, #{'start_line' => extract_line('$2')}).
OperationDefinition -> OperationType Name VariableDefinitions SelectionSet : build_ast_node('OperationDefinition', #{'operation' => '$1', 'name' => extract_binary('$2'), 'variable_definitions' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
OperationDefinition -> OperationType Name Directives SelectionSet : build_ast_node('OperationDefinition', #{'operation' => '$1', 'name' => extract_binary('$2'), 'directives' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
OperationDefinition -> OperationType Name VariableDefinitions Directives SelectionSet : build_ast_node('OperationDefinition', #{'operation' => '$1', 'name' => extract_binary('$2'), 'variable_definitions' => '$3', 'directives' => '$4', 'selection_set' => '$5'}, #{'start_line' => extract_line('$1')}).

Fragment -> 'fragment' FragmentName 'on' TypeCondition SelectionSet : build_ast_node('Fragment', #{'name' => '$2', 'type_condition' => '$4', 'selection_set' => '$5'}, #{'start_line' => extract_line('$1')}).
Fragment -> 'fragment' FragmentName 'on' TypeCondition Directives SelectionSet : build_ast_node('Fragment', #{'name' => '$2', 'type_condition' => '$4', 'directives' => '$5', 'selection_set' => '$6'}, #{'start_line' => extract_line('$1')}).

TypeCondition -> NamedType : '$1'.

VariableDefinitions -> '(' VariableDefinitionList ')' : '$2'.
VariableDefinitionList -> VariableDefinition : ['$1'].
VariableDefinitionList -> VariableDefinition VariableDefinitionList : ['$1'|'$2'].
VariableDefinition -> Variable ':' Type : build_ast_node('VariableDefinition', #{'variable' => '$1', 'type' => '$3'}, #{'start_line' => extract_line('$1')}).
VariableDefinition -> Variable ':' Type DefaultValue : build_ast_node('VariableDefinition', #{'variable' => '$1', 'type' => '$3', 'default_value' => '$4'}, #{'start_line' => extract_line('$1')}).
Variable -> '$' NameWithoutOn : build_ast_node('Variable', #{'name' => extract_binary('$2')}, #{'start_line' => extract_line('$1')}).
Variable -> '$' 'on' : build_ast_node('Variable', #{'name' => extract_binary('$2')}, #{'start_line' => extract_line('$1')}).

DefaultValue -> '=' Value : '$2'.

Type -> NamedType : '$1'.
Type -> ListType : '$1'.
Type -> NonNullType : '$1'.
NamedType -> Name : build_ast_node('NamedType', #{'name' => extract_binary('$1')}, #{'start_line' => extract_line('$1')}).
ListType -> '[' Type ']' : build_ast_node('ListType', #{'type' => '$2'}, #{'start_line' => extract_line('$1')}).
NonNullType -> NamedType '!' : build_ast_node('NonNullType', #{'type' => '$1'}, #{'start_line' => extract_line('$1')}).
NonNullType -> ListType '!' : build_ast_node('NonNullType', #{'type' => '$1'}, #{'start_line' => extract_line('$1')}).

SelectionSet -> '{' Selections '}' : build_ast_node('SelectionSet', #{'selections' => '$2'}, #{'start_line' => extract_line('$1'), 'end_line' => extract_line('$3')}).

Selections -> Selection : ['$1'].
Selections -> Selection Selections : ['$1'|'$2'].

Selection -> Field : '$1'.
Selection -> FragmentSpread : '$1'.
Selection -> InlineFragment : '$1'.

FragmentSpread -> '...' FragmentName : build_ast_node('FragmentSpread', #{'name' => '$2'}, #{'start_line' => extract_line('$1')}).
FragmentSpread -> '...' FragmentName Directives : build_ast_node('FragmentSpread', #{'name' => '$2', 'directives' => '$3'}, #{'start_line' => extract_line('$1')}).

InlineFragment -> '...' 'on' TypeCondition SelectionSet : build_ast_node('InlineFragment', #{'type_condition' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
InlineFragment -> '...' 'on' TypeCondition Directives SelectionSet : build_ast_node('InlineFragment', #{'type_condition' => '$3', 'directives' => '$4', 'selection_set' => '$5'}, #{'start_line' => extract_line('$1')}).
InlineFragment -> '...' Directives SelectionSet : build_ast_node('InlineFragment', #{'directives' => '$2', 'selection_set' => '$3'}, #{'start_line' => extract_line('$1')}).

FragmentName -> NameWithoutOn : extract_binary('$1').

Field -> Name : build_ast_node('Field', #{'name' => extract_binary('$1')}, #{'start_line' => extract_line('$1')}).
Field -> Name Arguments : build_ast_node('Field', #{'name' => extract_binary('$1'), 'arguments' => '$2'}, #{'start_line' => extract_line('$1')}).
Field -> Name Directives : build_ast_node('Field', #{'name' => extract_binary('$1'), 'directives' => '$2'}, #{'start_line' => extract_line('$1')}).
Field -> Name SelectionSet : build_ast_node('Field', #{'name' => extract_binary('$1'), 'selection_set' => '$2'}, #{'start_line' => extract_line('$1')}).
Field -> Name Directives SelectionSet : build_ast_node('Field', #{'name' => extract_binary('$1'), 'directives' => '$2', 'selection_set' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Name Arguments SelectionSet : build_ast_node('Field', #{'name' => extract_binary('$1'), 'arguments' => '$2', 'selection_set' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Name Arguments Directives : build_ast_node('Field', #{'name' => extract_binary('$1'), 'arguments' => '$2', 'directives' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Name Arguments Directives SelectionSet : build_ast_node('Field', #{'name' => extract_binary('$1'), 'arguments' => '$2', 'directives' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2')}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Arguments : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'arguments' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name SelectionSet : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'selection_set' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Arguments SelectionSet : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'arguments' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Directives : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'directives' => '$3'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Arguments Directives : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'arguments' => '$3', 'directives' => '$4'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Directives SelectionSet : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'directives' => '$3', 'selection_set' => '$4'}, #{'start_line' => extract_line('$1')}).
Field -> Alias Name Arguments Directives SelectionSet : build_ast_node('Field', #{'alias' => extract_binary('$1'), 'name' => extract_binary('$2'), 'arguments' => '$3', 'directives' => '$4', 'selection_set' => '$5'}, #{'start_line' => extract_line('$1')}).

Alias -> Name ':' : '$1'.

Arguments -> '(' ArgumentList ')' : '$2'.
ArgumentList -> Argument : ['$1'].
ArgumentList -> Argument ArgumentList : ['$1'|'$2'].
Argument -> NameWithoutOn ':' Value : build_ast_node('Argument', #{name => extract_binary('$1'), value => '$3'}, #{'start_line' => extract_line('$1')}).
Argument -> 'on' ':' Value : build_ast_node('Argument', #{name => extract_binary('$1'), value => '$3'}, #{'start_line' => extract_line('$1')}).

Directives -> Directive : ['$1'].
Directives -> Directive Directives : ['$1'|'$2'].
Directive -> '@' Name : build_ast_node('Directive', #{name => extract_binary('$2')}).
Directive -> '@' Name Arguments : build_ast_node('Directive', #{name => extract_binary('$2'), 'arguments' => '$3'}, #{'start_line' => extract_line('$1')}).

NameWithoutOn -> 'name' : '$1'.
NameWithoutOn -> 'query' : extract_binary('$1').
NameWithoutOn -> 'mutation' : extract_binary('$1').
NameWithoutOn -> 'subscription' : extract_binary('$1').
NameWithoutOn -> 'fragment' : extract_binary('$1').
NameWithoutOn -> 'type' : extract_binary('$1').
NameWithoutOn -> 'implements' : extract_binary('$1').
NameWithoutOn -> 'interface' : extract_binary('$1').
NameWithoutOn -> 'union' : extract_binary('$1').
NameWithoutOn -> 'scalar' : extract_binary('$1').
NameWithoutOn -> 'enum' : extract_binary('$1').
NameWithoutOn -> 'input' : extract_binary('$1').
NameWithoutOn -> 'extend' : extract_binary('$1').
NameWithoutOn -> 'null' : extract_binary('$1').

Name -> NameWithoutOn : '$1'.
Name -> 'on' : extract_binary('$1').

Value -> Variable : '$1'.
Value -> int_value : build_ast_node('IntValue', #{'value' => extract_integer('$1')}, #{'start_line' => extract_line('$1')}).
Value -> float_value : build_ast_node('FloatValue', #{'value' => extract_float('$1')}, #{'start_line' => extract_line('$1')}).
Value -> string_value : build_ast_node('StringValue', #{'value' => extract_quoted_string_token('$1')}, #{'start_line' => extract_line('$1')}).
Value -> boolean_value : build_ast_node('BooleanValue', #{'value' => extract_boolean('$1')}, #{'start_line' => extract_line('$1')}).
Value -> EnumValue : build_ast_node('EnumValue', #{'value' => '$1'}, #{'start_line' => extract_line('$1')}).
Value -> ListValue : build_ast_node('ListValue', #{'values' => '$1'}, #{'start_line' => extract_line('$1')}).
Value -> ObjectValue : build_ast_node('ObjectValue', #{'fields' => '$1'}, #{'start_line' => extract_line('$1')}).

EnumValue -> Name : extract_binary('$1').

ListValue -> '[' ']' : [].
ListValue -> '[' Values ']' : '$2'.
Values -> Value : ['$1'].
Values -> Value Values : ['$1'|'$2'].

ObjectValue -> '{' '}' : [].
ObjectValue -> '{' ObjectFields '}' : '$2'.
ObjectFields -> ObjectField : ['$1'].
ObjectFields -> ObjectField ObjectFields : ['$1'|'$2'].
ObjectField -> Name ':' Value : build_ast_node('ObjectField', #{'name' => extract_binary('$1'), 'value' => '$3'}, #{'start_line' => extract_line('$1')}).

TypeDefinition -> ObjectDefinition : '$1'.
TypeDefinition -> InterfaceDefinition : '$1'.
TypeDefinition -> UnionTypeDefinition : '$1'.
TypeDefinition -> ScalarTypeDefinition : '$1'.
TypeDefinition -> EnumTypeDefinition : '$1'.
TypeDefinition -> InputObjectDefinition : '$1'.
TypeDefinition -> TypeExtensionDefinition : '$1'.

ObjectDefinition -> 'type' Name '{' FieldDefinitionList '}' :
  build_ast_node('ObjectDefinition', #{'name' => extract_binary('$2'), 'fields' => '$4'}, #{'start_line' => extract_line('$1'), 'end_line' => extract_line('$5')}).
ObjectDefinition -> 'type' Name ImplementsInterfaces '{' FieldDefinitionList '}' :
  build_ast_node('ObjectDefinition', #{'name' => extract_binary('$2'), 'interfaces' => '$3', 'fields' => '$5'}, #{'start_line' => extract_line('$1'), 'end_line' => extract_line('$6')}).

ImplementsInterfaces -> 'implements' NamedTypeList : '$2'.

NamedTypeList -> NamedType : ['$1'].
NamedTypeList -> NamedType NamedTypeList : ['$1'|'$2'].

FieldDefinitionList -> FieldDefinition : ['$1'].
FieldDefinitionList -> FieldDefinition FieldDefinitionList : ['$1'|'$2'].
FieldDefinition -> Name ':' Type : build_ast_node('FieldDefinition', #{'name' => extract_binary('$1'), 'type' => '$3'}, #{'start_line' => extract_line('$1')}).
FieldDefinition -> Name ArgumentsDefinition ':' Type : build_ast_node('FieldDefinition', #{'name' => extract_binary('$1'), 'arguments' => '$2', 'type' => '$4'}, #{'start_line' => extract_line('$1')}).

ArgumentsDefinition -> '(' InputValueDefinitionList ')' : '$2'.

InputValueDefinitionList -> InputValueDefinition : ['$1'].
InputValueDefinitionList -> InputValueDefinition InputValueDefinitionList : ['$1'|'$2'].

InputValueDefinition -> Name ':' Type : build_ast_node('InputValueDefinition', #{'name' => extract_binary('$1'), 'type' => '$3'}, #{'start_line' => extract_line('$1')}).
InputValueDefinition -> Name ':' Type DefaultValue : build_ast_node('InputValueDefinition', #{'name' => extract_binary('$1'), 'type' => '$3', 'default_value' => '$4'}, #{'start_line' => extract_line('$1')}).

InterfaceDefinition -> 'interface' Name '{' FieldDefinitionList '}' :
  build_ast_node('InterfaceDefinition', #{'name' => extract_binary('$2'), 'fields' => '$4'}, #{'start_line' => extract_line('$1'), 'end_line' => extract_line('$5')}).

UnionTypeDefinition -> 'union' Name '=' UnionMembers :
  build_ast_node('UnionTypeDefinition', #{'name' => extract_binary('$2'), 'types' => '$4'}, #{'start_line' => extract_line('$1')}).

UnionMembers -> NamedType : ['$1'].
UnionMembers -> NamedType '|' UnionMembers : ['$1'|'$3'].

ScalarTypeDefinition -> 'scalar' Name : build_ast_node('ScalarTypeDefinition', #{'name' => extract_binary('$2')}, #{'start_line' => extract_line('$2')}).

EnumTypeDefinition -> 'enum' Name '{' EnumValueDefinitionList '}':
  build_ast_node('EnumTypeDefinition', #{'name' => extract_binary('$2'), 'values' => '$4'}, #{'start_line' => extract_line('$2'), 'end_line' => extract_line('$5')}).

EnumValueDefinitionList -> EnumValueDefinition : ['$1'].
EnumValueDefinitionList -> EnumValueDefinition EnumValueDefinitionList : ['$1'|'$2'].

EnumValueDefinition -> EnumValue : '$1'.

InputObjectDefinition -> 'input' Name '{' InputValueDefinitionList '}' :
  build_ast_node('InputObjectDefinition', #{'name' => extract_binary('$2'), 'fields' => '$4'}, #{'start_line' => extract_line('$2'), 'end_line' => extract_line('$5')}).

TypeExtensionDefinition -> 'extend' ObjectDefinition :
  build_ast_node('TypeExtensionDefinition', #{'definition' => '$2'}, #{'start_line' => extract_line('$1')}).


Erlang code.

extract_atom({Value, _Line}) -> Value.
extract_binary(Value) when is_binary(Value) -> Value;
extract_binary({Token, _Line}) -> list_to_binary(atom_to_list(Token));
extract_binary({_Token, _Line, Value}) -> list_to_binary(Value).
extract_quoted_string_token({_Token, _Line, Value}) -> list_to_binary(lists:sublist(Value, 2, length(Value) - 2)).
extract_integer({_Token, _Line, Value}) ->
  {Int, []} = string:to_integer(Value), Int.
extract_float({_Token, _Line, Value}) ->
  {Float, []} = string:to_float(Value), Float.
extract_boolean({_Token, _Line, "true"}) -> true;
extract_boolean({_Token, _Line, "false"}) -> false.
extract_line({_Token, Line}) -> Line;                                
extract_line({_Token, Line, _Value}) -> Line;
extract_line(_) -> nil.

extract_child_line([head|tail]) ->
    extract_child_line(head);
extract_child_line(#{loc := #{'start_line' := Line}}) ->
    Line;
extract_child_line(_) ->
    nil.

build_ast_node(Type, Node) ->
  build_ast_node(Type, Node, nil).
build_ast_node(Type, Node, #{'start_line' := nil}) ->
  build_ast_node(Type, Node, nil);
build_ast_node(Type, Node, Loc) ->
  'Elixir.Kernel':struct(list_to_atom("Elixir.Absinthe.Language." ++ atom_to_list(Type)), Node#{loc => Loc}).
