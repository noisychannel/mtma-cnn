#pragma once
#include <tuple>
#include <map>
#include "cnn/expr.h"

using namespace cnn::expr;

struct ExpCache {
  map<tuple<unsigned, unsigned>, Expression> srcExpCache;
  map<tuple<unsigned, unsigned>, Expression> tPhraseCache;
  map<tuple<unsigned, unsigned>, Expression> sPhraseCache;
  map<unsigned, Expression> lContextCache;
  map<unsigned, Expression> rContextCache;
};
