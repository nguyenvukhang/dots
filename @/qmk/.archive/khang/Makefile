USER := khang
KEEB := dz60
CONTEXT := -kb $(KEEB) -km $(USER)

c: # compile
	qmk compile -j 4 $(CONTEXT)
f: # flash
	qmk flash $(CONTEXT)
a: # all: compile and flash
	@make c
	@make f
lsp:
	qmk generate-compilation-database $(CONTEXT)
