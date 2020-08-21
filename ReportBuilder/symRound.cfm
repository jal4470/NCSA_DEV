<cfscript>
/**
* Symmetrically rounds any number to a specific decimal point, preventing a common &quot;rounding bias&quot; from skewing results.
* Ver 1.1: Made numDigits an optional parameter instead of required.
*
* @param theNumber      Number you want to round. (Required)
* @param numDigits      Number of decimal places to round to. (Optional)
* @return Returns a numeric value.
* @author Shawn Seley (shawnse@aol.com)
* @version 1.1, October 4, 2002
*/
function SymRound(theNumber) {
// The decimal-place-rounding foundation of this code was based on Sierra Bufe's (sierra@brighterfusion.com) RoundIt().
var x = 0;
var rounded_down = 0;

var numDigits = 0; // rounds to the nearest whole integer unless a decimal place is specified
if(ArrayLen(Arguments) GTE 2) numDigits = Arguments[2];

    // multiply by 10 to the power of the number of digits to be preserved, and remove its sign
    x = Abs(theNumber * (10 ^ numDigits));
    rounded_down = Int(x);

    // round off to an integer, checking for the exception first
    if((x -rounded_down EQ 0.5) and (not rounded_down mod 2)) {
        // number is an exact-middle "5" AND rounding down is the closest *even* result
        x = rounded_down;
    } else x = Round(Val(x)); // otherwise round normally

    // divide by 10 to the power of the number of digits to be preserved, and restore the number's sign
    return x / (10 ^ numDigits) * Sgn(theNumber);

}
</cfscript>