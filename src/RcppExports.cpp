// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// rcategorical
int rcategorical(NumericVector p);
RcppExport SEXP tidytopics_rcategorical(SEXP pSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type p(pSEXP);
    rcpp_result_gen = Rcpp::wrap(rcategorical(p));
    return rcpp_result_gen;
END_RCPP
}
// sample_vanilla_lda
IntegerVector sample_vanilla_lda(IntegerVector doc, IntegerVector type, IntegerVector z, int K, int D, int V, int iter, double beta, double alpha);
RcppExport SEXP tidytopics_sample_vanilla_lda(SEXP docSEXP, SEXP typeSEXP, SEXP zSEXP, SEXP KSEXP, SEXP DSEXP, SEXP VSEXP, SEXP iterSEXP, SEXP betaSEXP, SEXP alphaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< IntegerVector >::type doc(docSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type type(typeSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type z(zSEXP);
    Rcpp::traits::input_parameter< int >::type K(KSEXP);
    Rcpp::traits::input_parameter< int >::type D(DSEXP);
    Rcpp::traits::input_parameter< int >::type V(VSEXP);
    Rcpp::traits::input_parameter< int >::type iter(iterSEXP);
    Rcpp::traits::input_parameter< double >::type beta(betaSEXP);
    Rcpp::traits::input_parameter< double >::type alpha(alphaSEXP);
    rcpp_result_gen = Rcpp::wrap(sample_vanilla_lda(doc, type, z, K, D, V, iter, beta, alpha));
    return rcpp_result_gen;
END_RCPP
}
