PROJECTNAME=jn_mavg
PROJECTVERSION=1.0

INSTALLDIR=$(prefix)/$(LIBDIR)/$(PROJECTNAME)-$(PROJECTVERSION)/ebin
LIBDIR=$(shell erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell)

REBAR = rebar

all: app

app: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean
	rm -f erl_crash.dump
	rm -rf .eunit

# dev

devdeps:
	$(REBAR) -C rebar_dev.config get-deps


devapp: devdeps
	$(REBAR) -C rebar_dev.config compile

devclean:
	$(REBAR) -C rebar_dev.config clean

tests: clean app eunit

eunit:
	@$(REBAR) -C rebar_dev.config eunit skip_deps=true

build-plt:
	@$(DIALYZER) --build_plt \
		--apps kernel stdlib sasl inets crypto public_key ssl wx mnesia

dialyze:
	@$(DIALYZER) -r ebin \
		-Werror_handling -Wrace_conditions -Wunmatched_returns -Wunderspecs

docs:
	@$(REBAR) -C rebar_dev.config doc

install:
	mkdir -p $(INSTALLDIR)
	for f in ebin/*.beam; do install $$f $(INSTALLDIR); done
