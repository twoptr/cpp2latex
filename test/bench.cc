#include "benchmark/benchmark.h"
#include <cmath>
// #include "Isqrt.h"
#include <iostream>

/*
static void BM_Test(benchmark::State & state)
{
  unsigned long sum = 0;
  for (auto _ : state)
    {
      for( unsigned int i = 0; i < 1000000; ++i )
        sum += Math::sqrt(i);
    }
  std::cout << sum << "\n";
}
*/

static void BM2_Test(benchmark::State & state)
{
  unsigned long sum = 0;
  for (auto _ : state)
    {
      for( unsigned int i = 0; i < 1000000; ++i )
        sum += (unsigned)std::sqrt(i);
    }
  std::cout << sum << "\n";
}

//BENCHMARK(BM_Test);
BENCHMARK(BM2_Test);
