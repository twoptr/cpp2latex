// -*- c++ -*-
// (C) 2022 twoptr

%top{

#include <string>
#include <sstream>
#include <regex>

namespace
{
  int v_line = 0;
  std::string v_str;
  std::string v_comment;
  std::string v_buffer;
}

%}

%option lexer="Lexcpp"
%option outfile="tmp/pcpp.cc"
%option header-file="tmp/pcpp.h"

// %option debug
%option perf-report
%option nounicode

%class{

 public:

 void token( std::string & buffer,
             const std::string & t,
             const std::string & color)
 {
  buffer.append("{\\color{" + color + "}" + t + "}");
 }

 void keyword(const std::string & t)
 {
  std::string tmp = escape(t);
  token(v_buffer, tmp, "orange");
 }

 void type(const std::string & t)
 {
  std::string tmp = escape(t);
  token(v_buffer, tmp, "green");
 }

 void flush_buffer()
 {
  std::cout << "\t\t\t\t{\\tiny "
            << v_line << "} & \\texttt{ "
            << v_buffer << " } \\\\\n";

  v_buffer.clear();
 }

 void scomment(const std::string & t)
 {
  std::string tmp = escape(t);
  token(v_buffer, tmp, "gray!70");
 }

 std::string escape(const std::string & t)
 {
  std::string es;
  es.reserve(512);

  size_t idx = 0;
  const size_t len = t.size();

  while(idx < t.size())
    {
      if( t[idx] == '<' && idx+1 < len && t[idx+1] == '<' )
        {
          es.append("<{}<");
          idx+=2;
          continue;
        }

      if( t[idx] == '>' && idx+1 < len && t[idx+1] == '>' )
        {
          es.append(">{}>");
          idx+=2;
          continue;
        }

      if( t[idx] == '\\' )
        {
          es.append("\\textbackslash ");
          ++idx;
          continue;
        }

      if( t[idx] == ' ' )
        {
          es.append("\\enspace{}");
          ++idx;
          continue;
        }

      if(
         t[idx] == '#' ||
         t[idx] == '{' ||
         t[idx] == '}' ||
         t[idx] == '_' ||
         t[idx] == '%' ||
         t[idx] == '&'
          )
        {
          es.append("\\");
          es.append(std::string(1,t[idx]));
          ++idx;
          continue;
        }

      es.append(std::string(1,t[idx]));
      ++idx;
    }

  return es;
 }

%}

%init{
      std::cout << "\t\t\t\\begin{tabular}{>{\\columncolor{gray3}}cl}\n";
%}

%x X_COMMENT X_STRING

var    [A-Za-z0-9\_]+
std    "std::"{var}[ ]

%%

//----------------------------------------------
<X_COMMENT>{
"*/"           {
                v_comment.append(text());
                token(v_buffer, v_comment, "gray!70");
                v_comment.clear();

                start(INITIAL);
             };

\n             {
                  token(v_buffer, v_comment, "gray!70");
                  v_comment.clear();
                  flush_buffer();
                  ++v_line;
               }

[a-zA-Z0-9]+   { v_comment.append(text()); }

[ ]+           { std::string tmp = escape(text()); v_comment.append(tmp); }

">>"           { v_comment.append(">{}>"); }
"<<"           { v_comment.append("<{}<"); }

.              { std::string tmp = escape(text()); v_comment.append(tmp); }

}

//----------------------------------------------
<X_STRING>{
\" {
    char q = 34;
    start(INITIAL);
    std::string tmp = std::string(1,q);
    v_str.append(tmp);
    token(v_buffer, v_str, "blue");
}

\n {
    v_buffer.append(std::string("\"") + v_str);
    flush_buffer();
    ++v_line;
    v_str.clear();
}

">>"           { v_str.append(">{}>"); }
"<<"           { v_str.append("<{}<"); }

[ ]+           { std::string tmp = escape(text()); v_str.append(tmp); }

.              { std::string tmp = escape(text()); v_str.append(tmp); }

}

//----------------------------------------------
"/*"           { start(X_COMMENT); v_comment = "/*"; }

\"             { start(X_STRING); v_str = "\""; }

"//".+         { scomment(text()); }
"[[".+"]]"     { scomment(text()); }

"alignas"      { keyword(text()); }
"alignof"      { keyword(text()); }
"and"          { keyword(text()); }
"and_eq"       { keyword(text()); }
"asm"          { keyword(text()); }
"auto"         { keyword(text()); }
"bitand"       { keyword(text()); }
"bitor"        { keyword(text()); }
"break"        { keyword(text()); }
"case"         { keyword(text()); }
"catch"        { keyword(text()); }
"class"        { keyword(text()); }
"co_await"     { keyword(text()); }
"co_return"    { keyword(text()); }
"co_yield"     { keyword(text()); }
"compl"        { keyword(text()); }
"concept"      { keyword(text()); }
"const"        { keyword(text()); }
"const_cast"   { keyword(text()); }
"consteval"    { keyword(text()); }
"constexpr"    { keyword(text()); }
"constinit"    { keyword(text()); }
"continue"     { keyword(text()); }
"decltype"     { keyword(text()); }
"default"      { keyword(text()); }
"delete"       { keyword(text()); }
"do"           { keyword(text()); }
"dynamic_cast" { keyword(text()); }
"else"         { keyword(text()); }
"enum"         { keyword(text()); }
"explicit"     { keyword(text()); }
"export"       { keyword(text()); }
"extern"       { keyword(text()); }
"false"        { keyword(text()); }
"final"        { keyword(text()); }
"for"          { keyword(text()); }
"friend"       { keyword(text()); }
"if"           { keyword(text()); }
"import"       { keyword(text()); }
"inline"       { keyword(text()); }
"module"       { keyword(text()); }
"mutable"      { keyword(text()); }
"namespace"    { keyword(text()); }
"new"          { keyword(text()); }
"noexcept"     { keyword(text()); }
"not"          { keyword(text()); }
"not_eq"       { keyword(text()); }
"nullptr"      { keyword(text()); }
"operator"     { keyword(text()); }
"or"           { keyword(text()); }
"or_eq"        { keyword(text()); }
"override"     { keyword(text()); }
"private"      { keyword(text()); }
"protected"    { keyword(text()); }
"public"       { keyword(text()); }
"requires"     { keyword(text()); }
"return"       { keyword(text()); }
"sizeof"       { keyword(text()); }
"static"       { keyword(text()); }
"static_assert" { keyword(text()); }
"static_cast"  { keyword(text()); }
"struct"       { keyword(text()); }
"switch"       { keyword(text()); }
"template"     { keyword(text()); }
"thread_local" { keyword(text()); }
"throw"        { keyword(text()); }
"true"         { keyword(text()); }
"try"          { keyword(text()); }
"typedef"      { keyword(text()); }
"typeid"       { keyword(text()); }
"typename"     { keyword(text()); }
"union"        { keyword(text()); }
"using"        { keyword(text()); }
"virtual "     { keyword(text()); }
"volatile"     { keyword(text()); }
"while"        { keyword(text()); }
"xor"          { keyword(text()); }
"xor_eq"       { keyword(text()); }

".begin"       { keyword(text()); }
".end"         { keyword(text()); }


"void"         { type(text()); }
"bool"         { type(text()); }
"int"          { type(text()); }
"char"         { type(text()); }
"float"        { type(text()); }
"double"       { type(text()); }
"long"         { type(text()); }
"short"        { type(text()); }
"unsigned"     { type(text()); }
"signed"       { type(text()); }
"size_t"       { type(text()); }
"ssize_t"      { type(text()); }

{std}          { type(text()); }

"#include"     { keyword(text()); }
"#if"          { keyword(text()); }
"#else"        { keyword(text()); }
"#error"       { keyword(text()); }
"#elif"        { keyword(text()); }
"#ifdef"       { keyword(text()); }
"#endif"       { keyword(text()); }
"#define"      { keyword(text()); }
"#defined"     { keyword(text()); }
"#ifndef"      { keyword(text()); }
"#undef"       { keyword(text()); }
"#pragma"      { keyword(text()); }
"#__has_include"         { keyword(text()); }
"#__has_cpp_attribute"   { keyword(text()); }

[a-zA-Z0-9]+   { v_buffer.append(text()); }

[ ]+           { std::string tmp = escape(text()); v_buffer.append(tmp); }

">>"           { v_buffer.append(">{}>"); }
"<<"           { v_buffer.append("<{}<"); }

.              { std::string tmp = escape(text()); v_buffer.append(tmp); }

\n             { ++v_line; flush_buffer(); }


<<EOF>> {
  std::cout << "\t\t\t\\end{tabular}\n";
  //perf_report();
  return 0;
}

%%
