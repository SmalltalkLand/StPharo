evaluation
run: aSelector with: anArray in: aReceiver
	| method ctxt |
	method := (thisContext objectClass: aReceiver) methodDictionary at: aSelector .
	NoHooks  signal ifTrue: [ ^thisContext  object: aReceiver  withArgs: anArray executeMethod: method ].
	[(ctxt := Context newForMethod: method) StstepToHome: ctxt onStep: [ :sctxt| ] wrapStep: [:b|b on: NoHooks do: [:ex|ex resumeUnchecked: false]]] on: NoHooks do: [ :ex|ex resumeUnchecked: true ]