#pragma once

#include "Ints.h"

class Euler14
{
 public:
  Euler14(int argc, char *argv[]);

  void exec();

 private:
  const int m_argc;
  char ** m_argv;

  U64 m_start;
  U64 m_stop;

  bool m_show_sequence = false;
  bool m_show_detailresult = false;
};
