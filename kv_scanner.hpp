#ifndef __KV_SCANNER_HPP__
#define __KV_SCANNER_HPP__ 1


#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h> //Here defined yyFlexLexer
#endif


//include bison generated header file
#include "kv_parser.tab.hh"
#include "location.hh"

namespace KV{
    class KV_Scanner : public yyFlexLexer{
        public:
        //constructor: Call yyFlexLexer constructor, initialize the private yylval pointer to nullptr
            KV_Scanner(std::istream *in) : yyFlexLexer(in) {
                loc = new KV::KV_Parser::location_type();
            };

            virtual ~KV_Scanner() {}
            //yylex() now as virtual, can throw override error
            //Here we tell compiler we meant to define a new yylex below
            //This would get rid of override virtual function warning
            using FlexLexer::yylex;
            //define new yylex()
            virtual int yylex(KV::KV_Parser::semantic_type * const lval, KV::KV_Parser::location_type *location);
        private:
            KV::KV_Parser::semantic_type *yylval = nullptr;
            KV::KV_Parser::location_type *loc = nullptr;
    };
}
#endif