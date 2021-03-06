class Interpreter

  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    @global_scope = Scope.new
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    abstract_syntax_tree  = @parser.ast_tree(tokens) 
    last_value = abstract_syntax_tree.eval @global_scope
    last_value.to_s
  end

  def dump_state
    puts "----------------------"
    puts "PROGRAM DUMP START"
    puts "----------------------"
    puts "Global scope:"
    puts "----------------------"
    puts @global_scope # TODO write pretty print to_s for scope.rb
    puts "----------------------"
    puts "PROGRAM DUMP END"
    puts "----------------------"
  end

  def load_libraries
    filepath = File.dirname(__FILE__) + '/scheme_code/library_procedures.scm'
    filebody = IO.read(filepath)
    run(filebody)
  end
end
