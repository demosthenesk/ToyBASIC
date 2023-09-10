#include once "lexer.bi"
#include once "ast.bi"
#include once "parser.bi"

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
		Code = Code + line_+ chr(10)
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

Sub ShowTokens()
	'Get ALL Tokens
	While True
		CurrentToken = LexerGetNextToken()
		Print "Type: "; CurrentToken.Type_
		Print "Lexeme: "; CurrentToken.Lexeme
		Print "Value: "; CurrentToken.Value
		Print "LineNumber: "; CurrentToken.LineNumber
		Print
		if CurrentToken.Type_ = TokenType.TOKEN_EOF Then Exit While
		sleep
	Wend
	print "~~END LEXER~~"
	sleep
End sub

' Main program for testing the lexer
Sub Main()
	' Get the filename from the command-line argument
	OpenFile()
	'Initialize Lexer
	InitLexer(Code)
'	ShowTokens()

	' Build the AST
'	Dim AstRoot As AstNode Ptr = ParseEval()
	Dim AstRoot As AstNode Ptr = BuildAstFromTokens()
	' Visit and perform an operation on each node of the AST
'	VisitAstNodes(AstRoot)

	Result = EvaluateExpression(AstRoot, 0)
	Print "Result Main: "; Result
	print "~~END PARSING~~"
	sleep
End Sub

Main()
