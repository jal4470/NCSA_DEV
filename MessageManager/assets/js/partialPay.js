<!--
function getPrice(item){
var current=0;
var newamount=item.form.elements.price.value;
var newnum= (current*1) + (newamount*1);
item.form.elements.price_disabled.value=(newnum.toFixed(2));
}
// -->


<!--
function showPay(item) {
var pay = item.form.elements.partial_payment_cnt.value;
var div0 = "paybox2";
var div1 = "payment1";
var div2 = "payment2";
var div3 = "payment3";
var div4 = "payment4";
var div5 = "payment5";
var div6 = "payment6";
var div7 = "payment7";
var div8 = "payment8";
var div9 = "payment9";
var div10 = "payment10";
var div11 = "payment11";
var div12 = "payment12";
    if (pay == 0) {
        document.getElementById(div0).style.display = "none";
        document.getElementById(div1).style.display = "none";
        document.getElementById(div2).style.display = "none";
        document.getElementById(div3).style.display = "none";
        document.getElementById(div4).style.display = "none";
        document.getElementById(div5).style.display = "none";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 1) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "none";
        document.getElementById(div3).style.display = "none";
        document.getElementById(div4).style.display = "none";
        document.getElementById(div5).style.display = "none";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 2) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "none";
        document.getElementById(div4).style.display = "none";
        document.getElementById(div5).style.display = "none";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 3) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "none";
        document.getElementById(div5).style.display = "none";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 4) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "none";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 5) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "none";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 6) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "none";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 7) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "none";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 8) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "block";
        document.getElementById(div9).style.display = "none";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 9) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "block";
        document.getElementById(div9).style.display = "block";
        document.getElementById(div10).style.display = "none";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 10) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "block";
        document.getElementById(div9).style.display = "block";
        document.getElementById(div10).style.display = "block";
        document.getElementById(div11).style.display = "none";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 11) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "block";
        document.getElementById(div9).style.display = "block";
        document.getElementById(div10).style.display = "block";
        document.getElementById(div11).style.display = "block";
        document.getElementById(div12).style.display = "none";
    } 
    if (pay == 12) {
        document.getElementById(div0).style.display = "block";
        document.getElementById(div1).style.display = "block";
        document.getElementById(div2).style.display = "block";
        document.getElementById(div3).style.display = "block";
        document.getElementById(div4).style.display = "block";
        document.getElementById(div5).style.display = "block";
        document.getElementById(div6).style.display = "block";
        document.getElementById(div7).style.display = "block";
        document.getElementById(div8).style.display = "block";
        document.getElementById(div9).style.display = "block";
        document.getElementById(div10).style.display = "block";
        document.getElementById(div11).style.display = "block";
        document.getElementById(div12).style.display = "block";
    } 
    
}
// -->
