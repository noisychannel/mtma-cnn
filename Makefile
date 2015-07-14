CC=g++
#CNN_DIR = /Users/austinma/git/cnn/
CNN_DIR = /home/austinma/git/cnn
#CNN_DIR=/export/a04/gkumar/code/cnn/
#CNN_DIR=/Users/gaurav/Projects/cnn/
#EIGEN = /Users/austinma/git/eigen
EIGEN = /opt/tools/eigen-dev/
#EIGEN=/export/a04/gkumar/code/eigen/
EIGEN=/Users/gaurav/Projects/eigen/
CNN_BUILD_DIR=$(CNN_DIR)/build
INCS=-I$(CNN_DIR) -I$(CNN_BUILD_DIR) -I$(EIGEN)
LIBS=-L$(CNN_BUILD_DIR)/cnn/
FINAL=-lcnn -lboost_regex -lboost_serialization
CFLAGS=-std=c++11 -O3 -ffast-math -funroll-loops
#CFLAGS=-std=c++11 -O0 -g -DDEBUG
BINDIR=bin
OBJDIR=obj
SRCDIR=src

.PHONY: clean
all: $(BINDIR)/pro $(BINDIR)/rerank $(BINDIR)/pro_ebleu

clean:
	rm -rf $(BINDIR)/*
	rm -rf $(OBJDIR)/*

$(OBJDIR)/rnn_context_rule.o: $(SRCDIR)/rnn_context_rule.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/rnn_context_rule.cc -o $(OBJDIR)/rnn_context_rule.o

$(OBJDIR)/reranker.o: $(SRCDIR)/reranker.cc $(SRCDIR)/reranker.h $(SRCDIR)/kbest_hypothesis.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/reranker.cc -o $(OBJDIR)/reranker.o

$(OBJDIR)/kbestlist.o: $(SRCDIR)/kbestlist.h $(SRCDIR)/kbestlist.cc
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/kbestlist.cc -o $(OBJDIR)/kbestlist.o

$(OBJDIR)/utils.o: $(SRCDIR)/utils.cc $(SRCDIR)/utils.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/utils.cc -o $(OBJDIR)/utils.o

$(OBJDIR)/kbest_hypothesis.o: $(SRCDIR)/kbest_hypothesis.cc $(SRCDIR)/kbest_hypothesis.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/kbest_hypothesis.cc -o $(OBJDIR)/kbest_hypothesis.o

$(OBJDIR)/pro.o: $(SRCDIR)/pro.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/pair_sampler.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/pro.cc -o $(OBJDIR)/pro.o

$(OBJDIR)/pro_ebleu.o: $(SRCDIR)/pro_ebleu.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/kbestlist.h $(SRCDIR)/reranker.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/pro_ebleu.cc -o $(OBJDIR)/pro_ebleu.o

$(OBJDIR)/pro_gaurav.o: $(SRCDIR)/pro_gaurav.cc $(SRCDIR)/utils.h $(SRCDIR)/reranker.h $(SRCDIR)/rnn_context_rule.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/pro_gaurav.cc -o $(OBJDIR)/pro_gaurav.o

$(OBJDIR)/rerank.o: $(SRCDIR)/rerank.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/pair_sampler.h
	mkdir -p $(OBJDIR)
	g++ -c $(CFLAGS) $(INCS) $(SRCDIR)/rerank.cc -o $(OBJDIR)/rerank.o

$(BINDIR)/pro: $(OBJDIR)/pro.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/utils.o $(OBJDIR)/kbestlist.o
	mkdir -p $(BINDIR)
	g++ $(LIBS) $(OBJDIR)/pro.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/utils.o $(OBJDIR)/kbestlist.o -o $(BINDIR)/pro $(FINAL)

$(BINDIR)/pro_ebleu: $(OBJDIR)/pro_ebleu.o $(OBJDIR)/kbestlist.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/reranker.o
	mkdir -p $(BINDIR)
	g++ $(LIBS) $(OBJDIR)/pro_ebleu.o $(OBJDIR)/kbestlist.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/reranker.o -o $(BINDIR)/pro_ebleu $(FINAL)

$(BINDIR)/pro_gaurav: $(OBJDIR)/pro_gaurav.o $(OBJDIR)/utils.o $(OBJDIR)/reranker.o $(OBJDIR)/rnn_context_rule.o
	mkdir -p $(BINDIR)
	g++ $(LIBS) $(OBJDIR)/pro_gaurav.o $(OBJDIR)/utils.o $(OBJDIR)/reranker.o $(OBJDIR)/rnn_context_rule.o -o $(BINDIR)/pro_gaurav $(FINAL)

$(BINDIR)/rerank: $(OBJDIR)/rerank.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/kbestlist.o $(OBJDIR)/reranker.o
	mkdir -p $(BINDIR)
	g++ $(LIBS) $(OBJDIR)/rerank.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/kbestlist.o $(OBJDIR)/reranker.o -o $(BINDIR)/rerank $(FINAL)
