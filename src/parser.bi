#include once "lexer.bi"

declare Function Match(As TokenType) As Boolean
declare Function ParsePrimary() As AstNode Ptr
declare Function ParseExpression() As AstNode Ptr
declare Function ParseEval() As AstNode Ptr
declare Function EvaluateExpression(Node As AstNode Ptr) As Double
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

' Function to evaluate an AST expression and return the result
Function EvaluateExpression(Node As AstNode Ptr) As Double
    If Node = Null Then
        ' Handle error or invalid expression
        Return 0 ' You can handle errors accordingly
    End If

    Dim Result As Double = 0 ' Initialize Result outside the loop

    While Node->Type_ <> TokenType.TOKEN_EOF
        Select Case Node->Type_
            Case TokenType.TOKEN_NUMBER
                Result = Node->Value
            Case TokenType.TOKEN_PLUS
                Result = Result + EvaluateExpression(Node->Left_) + EvaluateExpression(Node->Right_)
            Case TokenType.TOKEN_MINUS
                Result = Result + EvaluateExpression(Node->Left_) - EvaluateExpression(Node->Right_)
            Case TokenType.TOKEN_MULTIPLY
                Result = Result + EvaluateExpression(Node->Left_) * EvaluateExpression(Node->Right_)
            Case TokenType.TOKEN_DIVIDE
                Dim RightValue As Double = EvaluateExpression(Node->Right_)
                If RightValue <> 0 Then
                    Result = Result + EvaluateExpression(Node->Left_) / RightValue
                Else
                    ' Handle division by zero error
                    Return 0 ' You can handle errors accordingly
                End If
            Case TokenType.TOKEN_LEFT_PAREN
                ' Handle open parenthesis: Evaluate the expression inside the parentheses
                Result = Result + EvaluateExpression(Node->Left_)
            Case Else
                ' Handle other cases or operators
                Return 0 ' You can handle errors or unsupported operators accordingly
        End Select

        ' Move to the next node
        Node = Node->Right_
    Wend

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
