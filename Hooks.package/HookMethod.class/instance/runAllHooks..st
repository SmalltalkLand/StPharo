accessing
runAllHooks: hargs
NoHooks signal ifTrue: [ ^self ].
	[allHooks do: [ :h|h valueWithArguments: hargs ]] on: NoHooks do: [ :ex|ex resumeUnchecked: true ]