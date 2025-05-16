.DEFAULT_GOAL := build

CC = g++ -std=c++2a -g

INCLUDE     = ./include
SRC         = ./src
BUILD       = ./build
TESTS       = ./tests
TESTS_BIN   = ./tests_bin
INSTALL-DATA = ./install-data


OPTS_SQLITE3 = `pkg-config --cflags --libs sqlite3`
OPTS_FMT     = `pkg-config --cflags --libs fmt`
OPTS_YAML_CPP = -L/usr/lib/x86_64-linux-gnu -lyaml-cpp -I/usr/local/include/yaml-cpp/
ALL_OPTS     = $(OPTS_FMT) $(OPTS_SQLITE3) $(OPTS_YAML_CPP)


PREFIX ?= /usr
DESTDIR ?=

BIN_PATH = $(DESTDIR)$(PREFIX)/bin
CFG_PATH = $(DESTDIR)/etc/qkw-config
MAN_PATH = $(DESTDIR)$(PREFIX)/share/man/man1

.PHONY: all help build install clean run-tests

all: build

help:
	@echo "\n | HELP MENU"
	@echo "=================================================================="
	@echo "\"make\" or \"make build\" : build qkw"
	@echo "\"make install\" : install qkw to system"
	@echo "\"make clean\" : clean build objects"
	@echo "\"make run-tests\" : build and run all tests"
	@echo "=================================================================="

build: utils dir cmd _help qkw cli
	@echo "--compiling--"
	$(CC) -o $(BUILD)/qkw -I$(INCLUDE) $(BUILD)/*.o $(ALL_OPTS)

install:
	@echo "--installing--"
	install -d $(BIN_PATH) $(CFG_PATH) $(MAN_PATH)
	install -m 0755 $(BUILD)/qkw $(BIN_PATH)/
	install -m 0644 $(INSTALL-DATA)/qkw.1.gz $(MAN_PATH)/
	install -m 0644 $(INSTALL-DATA)/userdata.db $(CFG_PATH)/
	install -m 0644 $(INSTALL-DATA)/qkw-config.yaml $(CFG_PATH)/

	@echo "--------------------------------------------------------"
	@echo " Please set QKW_CONFIG to /etc/qkw-config/qkw-config.yaml"
	@echo "--------------------------------------------------------"

clean:
	@echo "--cleaning--"
	rm -f $(BUILD)/*.o $(BUILD)/qkw $(TESTS_BIN)/*

run-tests: test-qkw test-cmd test-dir test-utils

test-utils: utils
	$(CC) -o $(TESTS_BIN)/$@ $(TESTS)/tests_utils.cpp $(BUILD)/*.o $(ALL_OPTS) -I$(INCLUDE)

test-qkw: utils qkw
	$(CC) -o $(TESTS_BIN)/$@ $(TESTS)/tests_qkw.cpp $(BUILD)/*.o $(ALL_OPTS) -I$(INCLUDE)

test-dir: utils qkw dir
	$(CC) -o $(TESTS_BIN)/$@ $(TESTS)/tests_dir.cpp $(BUILD)/*.o $(ALL_OPTS) -I$(INCLUDE)

test-cmd: utils qkw cmd
	$(CC) -o $(TESTS_BIN)/$@ $(TESTS)/tests_cmd.cpp $(BUILD)/*.o $(ALL_OPTS) -I$(INCLUDE)


cmd:
	$(CC) -o $(BUILD)/cmd.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/cmd.cpp

utils:
	$(CC) -o $(BUILD)/utils.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/utils.cpp

qkw:
	$(CC) -o $(BUILD)/qkw.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/qkw.cpp

dir:
	$(CC) -o $(BUILD)/dir.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/dir.cpp

cli:
	$(CC) -o $(BUILD)/cli.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/cli.cpp

_help:
	$(CC) -o $(BUILD)/help.o -I$(INCLUDE) $(ALL_OPTS) -c $(SRC)/help.cpp
