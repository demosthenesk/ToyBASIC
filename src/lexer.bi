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
    TOKEN_LESS_THAN
    TOKEN_GREATER_THAN
    TOKEN_LESS_THAN_OR_EQUAL_TO
    TOKEN_GREATER_THAN_OR_EQUAL_TO
    TOKEN_EQUAL_TO
    TOKEN_NOT_EQUAL_TO
    TOKEN_IF
    TOKEN_THEN
    TOKEN_ELSE
    TOKEN_ENDIF
    TOKEN_DOUBLE_QUOTES
    TOKEN_PRINT
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

Function IdentifyToken(Char As String) As Token
    ' Identify token type
    Dim Lexeme As String = ""
    Dim r As Token
    Select Case Char
        Case chr(34)
            r.Type_ = TokenType.TOKEN_DOUBLE_QUOTES
            r.Lexeme = chr(34)
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case Chr(10) ' Case NEWLINE
            r.Type_ = TokenType.TOKEN_NEWLINE
            r.Lexeme = Chr(10)
            r.Value = 0
            LineNumber = LineNumber + 1
            r.LineNumber = LineNumber
            Return r
        Case "+"
            r.Type_ = TokenType.TOKEN_PLUS
            r.Lexeme = "+"
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case "-"
            r.Type_ = TokenType.TOKEN_MINUS
            r.Lexeme = "-"
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case "*"
            r.Type_ = TokenType.TOKEN_MULTIPLY
            r.Lexeme = "*"
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case "/"
            r.Type_ = TokenType.TOKEN_DIVIDE
            r.Lexeme = "/"
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case "("
            r.Type_ = TokenType.TOKEN_LEFT_PAREN
            r.Lexeme = "("
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case ")"
            r.Type_ = TokenType.TOKEN_RIGHT_PAREN
            r.Lexeme = ")"
            r.Value = 0
            r.LineNumber = LineNumber
            Return r
        Case "<"
            Dim NextChar As String = Advance()
            If NextChar = "=" Then
                r.Type_ = TokenType.TOKEN_LESS_THAN_OR_EQUAL_TO
                r.Lexeme = "<="
                r.Value = 0
                r.LineNumber = LineNumber
            Else
                r.Type_ = TokenType.TOKEN_LESS_THAN
                r.Lexeme = "<"
                r.Value = 0
                r.LineNumber = LineNumber
                CurrentPosition = CurrentPosition - 1 ' Go back one character
            End If
            Return r
        Case ">"
            Dim NextChar As String = Advance()
            If NextChar = "=" Then
                r.Type_ = TokenType.TOKEN_GREATER_THAN_OR_EQUAL_TO
                r.Lexeme = ">="
                r.Value = 0
                r.LineNumber = LineNumber
            Else
                r.Type_ = TokenType.TOKEN_GREATER_THAN
                r.Lexeme = ">"
                r.Value = 0
                r.LineNumber = LineNumber
                CurrentPosition = CurrentPosition - 1 ' Go back one character
            End If
            Return r
        Case "="
            Dim NextChar As String = Advance()
            If NextChar = "=" Then
                r.Type_ = TokenType.TOKEN_EQUAL_TO
                r.Lexeme = "=="
                r.Value = 0
                r.LineNumber = LineNumber
            Else
                ' Handle assignment or other cases where "=" is not a relational operator
                r.Type_ = TokenType.TOKEN_IDENTIFIER
                r.Lexeme = "="
                r.Value = 0
                r.LineNumber = LineNumber
                CurrentPosition = CurrentPosition - 1 ' Go back one character
            End If
            Return r
        Case "!"
            Dim NextChar As String = Advance()
            If NextChar = "=" Then
                r.Type_ = TokenType.TOKEN_NOT_EQUAL_TO
                r.Lexeme = "!="
                r.Value = 0
                r.LineNumber = LineNumber
            Else
                ' Handle other cases where "!" is not part of "!="
                r.Type_ = TokenType.TOKEN_IDENTIFIER
                r.Lexeme = "!"
                r.Value = 0
                r.LineNumber = LineNumber
                CurrentPosition = CurrentPosition - 1 ' Go back one character
            End If
            Return r
        Case "0" To "9"
            ' Scan numbers
            While (Char >= "0" And Char <= "9") Or Char = "."
                Lexeme = Lexeme + Char
                Char = Advance()
            Wend
            If (Char <> " " Or Char <> Chr(9) Or Char <> Chr(10) Or Char <> Chr(13)) Then CurrentPosition = CurrentPosition - 1 ' Go back one character
            Dim Value As Double
            Value = Val(Lexeme)
            r.Type_ = TokenType.TOKEN_NUMBER
            r.Lexeme = Lexeme
            r.Value = Value
            r.LineNumber = LineNumber
            Return r
        Case Else
            ' Scan identifiers
            While (Char >= "0" And Char <= "9") Or (Char >= "A" And Char <= "Z") Or (Char >= "a" And Char <= "z") Or Char = "_"
                Lexeme = Lexeme + Char
                Char = Advance()
            Wend			'IF TOKEN
			If Lexeme = "IF" then
				r.Type_ = TokenType.TOKEN_IF
				r.Lexeme = Lexeme
				r.Value = 0
				r.LineNumber = LineNumber
				Return r
			endif
			'THEN TOKEN
			If Lexeme = "THEN" then
				r.Type_ = TokenType.TOKEN_THEN
				r.Lexeme = Lexeme
				r.Value = 0
				r.LineNumber = LineNumber
				Return r
			endif
			'ELSE TOKEN
			If Lexeme = "ELSE" then
				r.Type_ = TokenType.TOKEN_ELSE
				r.Lexeme = Lexeme
				r.Value = 0
				r.LineNumber = LineNumber
				Return r
			endif
			'ENDIF TOKEN
			If Lexeme = "ENDIF" then
				r.Type_ = TokenType.TOKEN_ENDIF
				r.Lexeme = Lexeme
				r.Value = 0
				r.LineNumber = LineNumber
				Return r
			endif
			'PRINT TOKEN
			If Lexeme = "PRINT" then
				r.Type_ = TokenType.TOKEN_PRINT
				r.Lexeme = Lexeme
				r.Value = 0
				r.LineNumber = LineNumber
				Return r
			endif
			If Char <> " " Then CurrentPosition = CurrentPosition - 1 ' Go back one character
			
			'TOKEN IDENTIFIER
			r.Type_ = TokenType.TOKEN_IDENTIFIER
			r.Lexeme = Lexeme
			r.Value = 0
			r.LineNumber = LineNumber
			Return r
    End Select
    r.Type_ = TokenType.TOKEN_EOF
    r.Lexeme = Chr(0)
    r.Value = 0
    r.LineNumber = LineNumber
    Return r
End Function

' Function to read a token from the source code
Function GetNextToken() As Token
	Dim Char As string
'	Do
	while Char <> chr(0)
		Char = Advance()
		return IdentifyToken(Char)
	wend
'	Loop While Char <> chr(0) 'or Char = " " Or Char = Chr(9) Or Char = Chr(10) Or Char = Chr(13)	'Loop until reach NULL=EOF, Or Char is whitespace
End Function