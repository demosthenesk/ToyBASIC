#include once "lexer.bi"
#define Null 0

Type AstNode
    Type_ As TokenType
    Lexeme As String
    Value As Double
    Left_ As AstNode Ptr
    Right_ As AstNode Ptr
End Type

declare Function BuildAstFromTokens() As AstNode Ptr
declare Function IsOperator(As TokenType) As Boolean

' Function to build the AST for an arithmetic expression
Function BuildAstFromTokens() As AstNode Ptr
    Dim AstRoot As AstNode Ptr = Allocate(Len(AstNode))
    AstRoot->Type_ = TokenType.TOKEN_ROOT
'    AstRoot->Lexeme = "AST_ROOT" ' Give it a descriptive name
print ""
sleep(1) 'FIXME if remove sleep(1) Aborting due to runtime error 14 ("abnormal termination" signal) in /home/user/Documents/Workspaces/freebasic/ToyBASIC/ast.bi::BUILDASTFROMTOKENS()
    AstRoot->Value = 0
    AstRoot->Left_ = Null
    AstRoot->Right_ = Null

    Dim CurrentNode As AstNode Ptr = AstRoot
    Dim Token_ As Token

    Do
        Token_ = LexerGetNextToken()

        while Token_.Type_ = TokenType.TOKEN_NEWLINE
			Token_ = LexerGetNextToken()
        wend

        If Token_.Type_ = TokenType.TOKEN_EOF Then
            Exit Do
        End If

'		print Token_.Type_
'		print Token_.Lexeme
		
        ' Create a new AST node for the token
        Dim TokenNode As AstNode Ptr = Allocate(Len(AstNode))
        TokenNode->Type_ = Token_.Type_
        TokenNode->Lexeme = Token_.Lexeme
        TokenNode->Value = Token_.Value
        TokenNode->Left_ = Null
        TokenNode->Right_ = Null

        ' If the current token is an operator, set it as the right child of the current node
        If IsOperator(TokenNode->Type_) Then
            CurrentNode->Right_ = TokenNode
        Else
            ' If it's not an operator, set it as the left child of the current node
            CurrentNode->Left_ = TokenNode
        End If

        ' Update the current node to the newly created node
        CurrentNode = TokenNode
    Loop

    Return AstRoot->Left_ ' Skip the initial EOF node
End Function

' Function to check if a token type represents an operator
Function IsOperator(TokenType2 As TokenType) As Boolean
	if (TokenType2 = TokenType.TOKEN_PLUS or TokenType2 = TokenType.TOKEN_MINUS or TokenType2 = TokenType.TOKEN_MULTIPLY or TokenType2 = TokenType.TOKEN_DIVIDE) then
		Return True
	Else
		Return False
	endif

End Function
