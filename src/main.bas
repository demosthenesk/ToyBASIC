#include "lexer.bi"

Dim shared Code As String

Sub OpenFile()
	DIM filename AS STRING
	filename = COMMAND(1)
	
	if len(filename) = 0 then
		Print "Please provide a code file."
		Print "Usage: ./ToyBASIC <filename>"
		Print "Press any key to terminate..."
		sleep
		End
	EndIf
	
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
	
	dim c as string = Mid(Code, Len(Code), 1)
	'check last char to be whitespace
	if (c <> " " and c <> Chr(9) and c <> Chr(10) and c <> Chr(13)) then
		Print "Last character of file must be a whitespace character..."
		Print "Press any key to terminate..."
		sleep
		End
	endif
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
