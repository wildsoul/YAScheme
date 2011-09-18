class ListNode < AstNode
  include PrimitiveProcedures  

  def eval(scope=Scope.new)
    arguments  = children[1..children.length]
    procedure = eval_first_element children[0], scope
    if procedure.class == LambdaNode
      procedure.call_with_arguments arguments, scope
    else
      primitive_procedure_call procedure, arguments, scope
    end
  end

  def eval_first_element(first_element, scope)
    if first_element.class == ListNode
      first_element = first_element.eval scope
    else
      first_element = first_element.node_value
    end
  end

  def primitive_procedure_call(name, argument_nodes, scope)
    if self.respond_to? "eval_#{name}"
      self.send "eval_#{name}", argument_nodes, scope
    else
      eval_call_lambda name, argument_nodes, scope
    end    
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
