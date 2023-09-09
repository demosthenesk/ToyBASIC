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

' Function to build the AST for all tokens
Function BuildAstFromTokens() As AstNode Ptr
    Dim AstRoot As AstNode Ptr = Allocate(Len(AstNode))
    AstRoot->Type_ = TokenType.TOKEN_ROOT
'    AstRoot->Lexeme = "" 'FIXME pops up a blank window
print ""
sleep(1)
    AstRoot->Value = 0
    AstRoot->Left_ = Null
    AstRoot->Right_ = Null


    Dim CurrentNode As AstNode Ptr = AstRoot
    Dim Token_ As Token
    Dim TokenNode As AstNode Ptr

    Do
        Token_ = LexerGetNextToken()

        If Token_.Type_ = TokenType.TOKEN_EOF Then
            Exit Do
        End If

        ' Create a new AST node for the token
        TokenNode = Allocate(Len(AstNode))
        TokenNode->Type_ = Token_.Type_
        TokenNode->Lexeme = Token_.Lexeme
        TokenNode->Value = Token_.Value
        TokenNode->Left_ = Null
        TokenNode->Right_ = Null

        ' Append the new node to the right of the current node
        CurrentNode->Right_ = TokenNode
        CurrentNode = TokenNode
    Loop

    Return AstRoot->Right_ ' Skip the initial EOF node
End Function