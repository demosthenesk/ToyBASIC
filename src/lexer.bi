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
    TOKEN_NEWLINE
End Enum

' Define a data structure to represent tokens
Type Token
	Type_ As TokenType
	Lexeme As String
	Value As Double ' For numeric tokens
	LineNumber As uinteger
End Type

' Global variables
Dim Shared CurrentToken As Token
Dim Shared SourceCode As String
Dim Shared CurrentPosition As Integer
Dim Shared LineNumber As uinteger

' Function to initialize the lexer
Sub InitLexer(Code As String)
	SourceCode = Code
	CurrentPosition = 1
	LineNumber = 1
End Sub

' Function to advance to the next character in the source code
Function Advance() As string
	Dim Char As string
	If CurrentPosition <= Len(SourceCode) Then
		Char = Mid(SourceCode, CurrentPosition, 1)
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
		Case chr(10) 'Case NEWLINE
			r.Type_= TokenType.TOKEN_NEWLINE
			r.Lexeme= chr(10)
			r.Value=0
			LineNumber=LineNumber+1
			r.LineNumber = LineNumber
			Return r
		Case "+"
			r.Type_= TokenType.TOKEN_PLUS
			r.Lexeme= "+"
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case "-"
			r.Type_= TokenType.TOKEN_MINUS
			r.Lexeme= "-"
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case "*"
			r.Type_= TokenType.TOKEN_MULTIPLY
			r.Lexeme= "*"
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case "/"
			r.Type_= TokenType.TOKEN_DIVIDE
			r.Lexeme= "/"
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case "("
			r.Type_= TokenType.TOKEN_LEFT_PAREN
			r.Lexeme= "("
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case ")"
			r.Type_= TokenType.TOKEN_RIGHT_PAREN
			r.Lexeme= ")"
			r.Value=0
			r.LineNumber = LineNumber
            Return r
        Case "0" To "9"
            ' Scan numbers
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
			r.LineNumber = LineNumber
            Return r
        Case Else
        ' Scan identifiers
        While (Char >= "A" And Char <= "Z") Or (Char >= "a" And Char <= "z")
			Lexeme = Lexeme + Char
			Char = Advance()
		Wend
		if Char <>" " then CurrentPosition = CurrentPosition - 1 ' Go back one character
		r.Type_= TokenType.TOKEN_IDENTIFIER
		r.Lexeme= Lexeme
		r.Value=0
		r.LineNumber = LineNumber
		Return r
	End Select
	r.Type_= TokenType.TOKEN_EOF
	r.Lexeme = chr(0)
	r.Value=0
	r.LineNumber = LineNumber
	Return r
end function

' Function to read a token from the source code
Function GetNextToken() As Token
	Dim Char As string
'	Do
	while Char <> chr(0)
		Char = Advance()
		return IndetifyToken(Char)
	wend
'	Loop While Char <> chr(0) 'or Char = " " Or Char = Chr(9) Or Char = Chr(10) Or Char = Chr(13)	'Loop until reach NULL=EOF, Or Char is whitespace
End Function