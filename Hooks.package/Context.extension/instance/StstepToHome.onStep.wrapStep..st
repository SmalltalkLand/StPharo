*Hooks
StstepToHome: aContext onStep: b wrapStep: wb
	"Resume self until the home of top context is aContext.  Top context may be a block context."

	| home ctxt here error topContext context |
	
	here := thisContext.
	ctxt := wb value: [self step].
	b value: ctxt.
	ctxt = self ifFalse: [ 
		"Insert ensure and exception handler contexts under aSender"
		error := nil.
		context := aContext insertSender: (Context
			contextOn: UnhandledError do: [:ex |
				error ifNil: [
					error := ex exception.
					topContext := thisContext.
					ex resumeUnchecked: here jump ]
						ifNotNil: [ ex pass ]]).
	].
	home := aContext home.
	home == ctxt home ifTrue: [ ^{ctxt. nil} ].
	
	[ctxt := wb value: [ctxt step].
	b value: ctxt.
	error ifNotNil: [
		"remove above inserted ensure and handler contexts"
		context ifNotNil: [aContext terminateTo: context sender].
		^ {ctxt. error}].
	
	home == ctxt home] whileFalse: [
		home isDead ifTrue: [^ {ctxt. nil}]
	].
	"remove above inserted ensure and handler contexts"
	context ifNotNil: [aContext terminateTo: context sender].
	^ {ctxt. nil}