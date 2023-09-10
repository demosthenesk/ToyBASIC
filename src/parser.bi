#include once "lexer.bi"

declare Function Match(As TokenType) As Boolean
declare Function ParsePrimary() As AstNode Ptr
declare Function ParseExpression() As AstNode Ptr
declare Function ParseEval() As AstNode Ptr
declare Function EvaluateExpression(As AstNode Ptr, As double) As Double
declare Sub VisitAstNodes(As AstNode Ptr)
declare Function ParseTerm() As AstNode Ptr

' Function to match a token type (helper function)
Function Match(TokenTypeToMatch As TokenType) As Boolean
    If CurrentToken.Type_ = TokenTypeToMatch Then
        CurrentToken = LexerGetNextToken()
        Return True
    Else
        Return False
    End If
End Function

' Function to parse a term (multiplication or division)
Function ParseTerm() As AstNode Ptr
    Dim LeftOperand As AstNode Ptr = ParsePrimary()
    
    While CurrentToken.Type_ = TokenType.TOKEN_MULTIPLY Or CurrentToken.Type_ = TokenType.TOKEN_DIVIDE
        Dim Operator_ As TokenType = CurrentToken.Type_
        CurrentToken = LexerGetNextToken()
        Dim RightOperand As AstNode Ptr = ParsePrimary()
        
        ' Create a new AST node for the binary operation
        Dim Node As AstNode Ptr = Allocate(Len(AstNode))
        Node->Type_ = Operator_
        Node->Left_ = LeftOperand
        Node->Right_ = RightOperand
        Node->Value = CurrentToken.Value ' You can set the actual value later if needed
        
        LeftOperand = Node
    Wend
    
    Return LeftOperand
End Function

' Function to parse an expression and build the AST with correct operator precedence
Function ParseExpression() As AstNode Ptr
    Dim LeftOperand As AstNode Ptr = ParseTerm()
    
    While CurrentToken.Type_ = TokenType.TOKEN_PLUS Or CurrentToken.Type_ = TokenType.TOKEN_MINUS
        Dim Operator_ As TokenType = CurrentToken.Type_
        CurrentToken = LexerGetNextToken()
        Dim RightOperand As AstNode Ptr = ParseTerm()
        
        ' Create a new AST node for the binary operation
        Dim Node As AstNode Ptr = Allocate(Len(AstNode))
        Node->Type_ = Operator_
        Node->Left_ = LeftOperand
        Node->Right_ = RightOperand
        Node->Value = CurrentToken.Value ' You can set the actual value later if needed
        
        LeftOperand = Node
    Wend
    
    Return LeftOperand
End Function

' Function to parse a primary expression (numbers or parentheses)
Function ParsePrimary() As AstNode Ptr
    Dim Node As AstNode Ptr
    Select Case CurrentToken.Type_
        Case TokenType.TOKEN_NUMBER
            Node = Allocate(Len(AstNode))
            Node->Type_ = TokenType.TOKEN_NUMBER
            Node->Value = Val(CurrentToken.Lexeme)
            Node->Left_ = Null
            Node->Right_ = Null
            CurrentToken = LexerGetNextToken()
        Case TokenType.TOKEN_LEFT_PAREN
            Match(TokenType.TOKEN_LEFT_PAREN)
            Node = ParseExpression()
            Match(TokenType.TOKEN_RIGHT_PAREN)
        Case Else
            ' Handle unexpected token or error
            Node = Null
    End Select
    Return Node
End Function

' Function to parse and evaluate a full expression (entry point)
Function ParseEval() As AstNode Ptr
    CurrentToken = LexerGetNextToken()
    Return ParseExpression()
End Function

Dim shared Result As Double = 0 ' Initialize Result outside the loop

' Function to evaluate an AST expression and return the result
Function EvaluateExpression(Node As AstNode Ptr, Result as double) As Double

    If Node = Null Then
        ' Handle error or invalid expression
        Print "Null Ast Node!"
		'Result = Result + 0
'        Return Result        
		Return 0
    End If

'    While (Node <> Null)
'		if Node->Type_ = TokenType.TOKEN_EOF then exit while
'		print "Type: " & Node->Type_
'		print "Lexeme: " & Node->Lexeme
'		print "Value: " & Node->Value
'		print "Left: " & Node->Left_
'		print "Right: " & Node->Right_
'		print ""

        Select Case Node->Type_
            Case TokenType.TOKEN_NUMBER
                Result = Node->Value
				print "NUMBER= " & Result
            Case TokenType.TOKEN_PLUS
				print "PLUS"
				print "Node->Left_: " & Node->Left_->Value
				print "PLUS Result before: " & Result
				Result = Result + EvaluateExpression(Node->Left_, Result)
				print "PLUS Result after: " & Result
				print
            Case TokenType.TOKEN_MINUS
				print "MINUS"
				print "Node->Left_: " & Node->Left_->Value
				print "MINUS Result before: " & Result
                Result = Result - EvaluateExpression(Node->Left_, Result)
				print "MINUS Result after: " & Result
				print
			Case TokenType.TOKEN_MULTIPLY
				print "MULTIPLY"
				print "Node->Left_: " & Node->Left_->Value
				print "MULTIPLY Result before: " & Result
                Result = Result * EvaluateExpression(Node->Left_, Result)
				print "MULTIPLY Result after: " & Result
				print
'            Case TokenType.TOKEN_DIVIDE
'                Dim RightValue As Double = EvaluateExpression(Node->Right_)
'                If RightValue <> 0 Then
'                    Result = Result * EvaluateExpression(Node->Left_) / RightValue
'                Else
'                    ' Handle division by zero error
'                    Print "Error: Division by zero."
'                    Print "Terminate interpreter"
'                    End
''                    Return 0 ' You can handle errors accordingly
'                End If
'            Case TokenType.TOKEN_LEFT_PAREN
'                ' Handle open parenthesis: Evaluate the expression inside the parentheses
'                Result = EvaluateExpression(Node->Left_)
'            Case TokenType.TOKEN_RIGHT_PAREN
'                ' Handle close parenthesis: Continue evaluating the expression after parentheses
'                Result = EvaluateExpression(Node->Left_)
'            Case TokenType.TOKEN_IDENTIFIER
'				print "IDENTIFIER Lexeme asc(): " & asc(Node->Lexeme)
'                ' Handle identifiers (customize this based on your use)
'                ' For example, you might have a symbol table to look up variable values.
'                ' Result = LookUpVariableValue(Node->Lexeme)
'                ' This is a placeholder; you should implement the logic for identifiers.
'            Case TokenType.TOKEN_NEWLINE
'                Result = Result + 0
            Case Else
                ' Handle other cases or operators
                Print "Node->Type_:" & Node->Type_
                Print "Error: Unsupported operators"
                Print "Terminate interpreter"
                End
                Return 0 ' You can handle errors or unsupported operators accordingly
        End Select

        ' Move to the next node
		if Node <> Null then
			Node = Node->Right_
			if Node <> Null then
				Result = EvaluateExpression(Node, Result)
			endif
		endif
		

'        If Node = Null Then
'			dim Node As AstNode ptr
'			Node = Node->Right_
'            ' Handle error or invalid expression
'            Print "Null Ast Node, returning 0"
''            Return 0 ' You can handle errors accordingly
'        End If
'    Wend

	print "FINAL Result: " & Result
    Return Result
End Function


' Subroutine to visit each node of the AST rooted at AstRoot
Sub VisitAstNodes(AstRoot As AstNode Ptr)
    If AstRoot = Null Then
        Return
    End If
    
    ' Perform some operation on the current node (e.g., print its type or value)
    Print "Node Type: "; AstRoot->Type_
    Print "Node Value: "; AstRoot->Value
    
    ' Recursively visit the left and right children
    VisitAstNodes(AstRoot->Left_)
    VisitAstNodes(AstRoot->Right_)
End Sub
