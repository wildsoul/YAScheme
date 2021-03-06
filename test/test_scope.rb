require File.dirname(__FILE__) + '/test_helper.rb'

class TestScope < Test::Unit::TestCase
  
  def setup
    @global_scope = Scope.new
  end
  
  def test_created_global_scope_has_single_stack_debth
    global = Scope.new
    assert_not_nil global
    assert_equal 1, global.symbol_table_stack.count
  end

  def test_local_scope_has_larger_stack_debth
    inner = Scope.new(@global_scope)
    assert_equal 2, inner.symbol_table_stack.count
    inner_inner = Scope.new(inner)
    assert_equal 3, inner_inner.symbol_table_stack.count
  end

  def test_variable_definition
    variable = StringNode.new "1"
    @global_scope.define "foo", variable
    assert_equal variable, @global_scope.symbol_table_stack[0]["foo"]
  end

  def test_variable_lookup
    variable = StringNode.new "2"
    @global_scope.symbol_table_stack[0]["foo"] = variable
    assert_equal variable, @global_scope.lookup("foo")
  end
  
  def test_local_scopes_sees_outer_variables
    variable = StringNode.new "3"
    @global_scope.define "foo", variable
    local_scope = Scope.new(@global_scope)
    assert_equal variable, local_scope.lookup("foo")
  end

  def test_local_variable_definitions_not_visible_to_outer_scopes
    local_scope = Scope.new(@global_scope)
    local_scope.define "foo", StringNode.new("inner")
    assert_equal nil, @global_scope.lookup("foo")
  end
  
  def test_deep_nested_block_sees_all_containing_scopes
    global_var = StringNode.new("global")
    @global_scope.define "foo", global_var
    inner_scope = Scope.new(@global_scope)
    inner_inner_scope = Scope.new(inner_scope)
    assert_equal global_var, inner_inner_scope.lookup("foo")
  end

  def test_deep_nested_block_sees_new_bindings_of_containing_scopes
    global_var = StringNode.new("global")
    inner_scope = Scope.new(@global_scope)
    inner_inner_scope = Scope.new(inner_scope)
    @global_scope.define "foo", global_var
    assert_equal global_var, inner_inner_scope.lookup("foo")
  end

  def test_inner_local_variable_shadows_outer_local_variable
    global_var = StringNode.new("global")
    @global_scope.define "foo", global_var
    inner_scope = Scope.new(@global_scope)
    inner_var = StringNode.new("inner shadow")
    inner_scope.define "foo", inner_var
    assert_equal inner_var, inner_scope.lookup("foo")
  end

  def test_changing_inner_shadowed_variables_doesnt_affect_outer_variables
    global_var = StringNode.new("global")
    @global_scope.define "foo", global_var
    assert_equal global_var, @global_scope.lookup("foo")
    inner_scope = Scope.new(@global_scope)
    inner_var = StringNode.new("inner shadow")
    inner_scope.define "foo", inner_var
    assert_equal global_var, @global_scope.lookup("foo")
  end
  

  # TODO: lexical scope/binding
  
end
