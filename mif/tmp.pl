$edc_sep        = ',';
$edc_sep_e      = ',';
$edc_seq        = ',';
$edc_seq_e      = ',';
$edc_or         = '|';
$edc_or_e       = '\|';
$edc_and        = '&';
$edc_and_e      = '&';

$edc_grpo       = '(';
$edc_grpo_e     = '\(';
$edc_grpc       = ')';
$edc_grpc_e     = '\)';

$edc_plus       = '+';
$edc_plus_e     = '\+';
$edc_opt        = '?';
$edc_opt_e      = '\?';
$edc_rep        = '*';
$edc_rep_e      = '\*';

$elem_keywords  = '<TEXT\\?>|<TEXTONLY\\?>';
$elem_spchars   = "$edc_seq_e$edc_or_e$edc_and_e$edc_grpo_e$edc_grpc_e".
                  "$edc_plus_e$edc_opt_e$edc_rep_e$mso$msc".
                  '\[\]%';
$model_chars    = "$edc_seq_e$edc_or_e$edc_and_e$edc_grpo_e$edc_grpc_e".
                  "$edc_plus_e$edc_opt_e$edc_rep_e";
$grp_chars      = "$edc_grpo_e$edc_grpc_e";
$oi_chars       = "$edc_plus_e$edc_opt_e$edc_rep_e";


$str = "Conditionals? , (Head? , ((((Bridge Head | List | List Continue | Para) | (Caution | Note | Warning) | (Equation | Example Block | Figure Frame | Para No Wrap | Labeled List | Labeled List Tight | Labeled List Wide | Labeled List Wide Tight | Syntax Diagram | Table | Example Block Verbatim))*))*)";

@array = split(/([$model_chars])/o, $str);
# $str =~ s/[$grp_chars$oi_chars]//go;
# @array = split(/[$edc_seq_e$edc_and_e$edc_or_e]/o, $str);
grep(s/^\s*(.*[^\s])\s*$/\1/, @array);

# print "@array\n";
foreach (@array) {
    print "#$_#\n";
}
