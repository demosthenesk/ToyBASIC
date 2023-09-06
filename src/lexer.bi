' Simple Lexer in FreeBASIC

' Define token types
Enum TokenType
    TOKEN_EOF = 0
    TOKEN_IDENTIFIER
    TOKEN_NUMBER
    TOKEN_PLUS
    TOKEN_MINUS
    TOKEN_MULTIPLY
    TOKEN_DIVIDE
    TOKEN_LEFT_PAREN
    TOKEN_RIGHT_PAREN
End Enum

' Define a data structure to represent tokens
Type Token
    Type_ As TokenType
    Lexeme As String
    Value As Double ' For numeric tokens
End Type

' Global variables
Dim Shared CurrentToken As Token
Dim Shared SourceCode As String
Dim Shared CurrentPosition As Integer

' Function to initialize the lexer
Sub InitLexer(Code As String)
    SourceCode = Code
    CurrentPosition = 1
End Sub

' Function to advance to the next character in the source code
Function Advance() As string
    Dim Char As string
    If CurrentPosition <= Len(SourceCode) Then
        Char = Mid(SourceCode, CurrentPosition, 1) 'FIXME Mid returns 2 chars, example 1+
        CurrentPosition = CurrentPosition + 1
   elseif CurrentPosition > Len(SourceCode) Then
        Char = Chr(0) ' End of file marker
    End If
    Return Char
End Function

function IndetifyToken(Char as string) As Token
    ' Identify token type
	Dim Lexeme As String = ""
	dim r as Token
	Select Case Char
        Case "+"
			r.Type_= TokenType.TOKEN_PLUS
			r.Lexeme= "+"
			r.Value=0
            Return r
        Case "-"
			r.Type_= TokenType.TOKEN_MINUS
			r.Lexeme= "-"
			r.Value=0
            Return r
        Case "*"
			r.Type_= TokenType.TOKEN_MULTIPLY
			r.Lexeme= "*"
			r.Value=0
            Return r
        Case "/"
			r.Type_= TokenType.TOKEN_DIVIDE
			r.Lexeme= "/"
			r.Value=0
            Return r
        Case "("
			r.Type_= TokenType.TOKEN_LEFT_PAREN
			r.Lexeme= "("
			r.Value=0
            Return r
        Case ")"
			r.Type_= TokenType.TOKEN_RIGHT_PAREN
			r.Lexeme= ")"
			r.Value=0
            Return r
        Case "0" To "9"
            ' Parse numbers
            While (Char >= "0" And Char <= "9") Or Char = "."
                Lexeme = Lexeme + Char
                Char = Advance()
            Wend
			if (Char <>" " Or Char <> Chr(9) Or Char <> Chr(10) Or Char <> Chr(13)) then CurrentPosition = CurrentPosition - 1 ' Go back one character
            Dim Value As Double
            Value = Val(Lexeme)
			r.Type_= TokenType.TOKEN_NUMBER
			r.Lexeme= Lexeme
			r.Value=Value
            Return r
        Case Else
        ' Parse identifiers
        While (Char >= "A" And Char <= "Z") Or (Char >= "a" And Char <= "z")
			Lexeme = Lexeme + Char
			Char = Advance()
		Wend
'		if (Char <>" " Or Char <> Chr(9) Or Char <> Chr(10) Or Char <> Chr(13)) then CurrentPosition = CurrentPosition - 1 ' Go back one character
		if Char <>" " then CurrentPosition = CurrentPosition - 1 ' Go back one character
		r.Type_= TokenType.TOKEN_IDENTIFIER
		r.Lexeme= Lexeme
		r.Value=0
		Return r
	End Select
	r.Type_= TokenType.TOKEN_EOF
	r.Lexeme = chr(0)
	r.Value=0
	Return r
end function

' Function to read a token from the source code
Function GetNextToken() As Token
	Dim Char As string

	Do
		Char = Advance()
		return IndetifyToken(Char)
	Loop While Char <> chr(0)
'	Loop While Char = " " Or Char = Chr(9) Or Char = Chr(10) Or Char = Chr(13) or CurrentPosition <= Len(SourceCode)
	' Skip whitespace characters
'	Loop While Char = " " Or Char = Chr(9) Or Char = Chr(10) Or Char = Chr(13)

End Function