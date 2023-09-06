#include "lexer.bi"

Dim shared Code As String

Sub OpenFile()
	DIM filename AS STRING
	filename = COMMAND(1)

	' Try to open the file
	DIM file AS INTEGER
	file = FREEFILE
	OPEN filename FOR INPUT AS file

	' Check if the file was successfully opened
	IF LOF(file) = -1 THEN
		PRINT "Error: Unable to open file " + filename
		CLOSE file
	END IF

	' Read and print the contents of the file
	DIM line_ AS STRING
	WHILE NOT EOF(file)
		LINE INPUT #file, line_
		Code = Code +" "+ line_
	WEND

	' Close the file
	CLOSE file
End Sub

' Main program for testing the lexer
Sub Main()
	' Get the filename from the command-line argument
	OpenFile()

	'without spaces works
'	Code = "1+32*(356+x)"
	
	'with spaces work
	'Code = "1 + 32 * ( 3 + xzy+q)"
	InitLexer(Code)

	While True
		CurrentToken = GetNextToken()
		If CurrentPosition > Len(SourceCode) Then Exit While
		if CurrentToken.Type_ = TokenType.TOKEN_EOF Then Exit While
		Print "Type: "; CurrentToken.Type_
		Print "Lexeme: "; CurrentToken.Lexeme
		Print "Value: "; CurrentToken.Value
		Print
		sleep
	Wend
	print "~~END~~"
	sleep
End Sub

Main()
