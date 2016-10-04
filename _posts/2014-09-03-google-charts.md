---
layout: post
comments:  true
title: "Google Charts in R Markdown"
date: 2014-09-03 20:30:00
published: true
categories: ['R']
excerpt_seperator: <!--more-->
output:
  html_document:
    mathjax:  default
---

* will be replaced by TOC
{:toc}





## Introduction


An excellent little post ([Zoom, zoom googleVis](http://lamages.blogspot.com/2014/09/zoom-zoom-googlevis.html)) showed up recently on [R-Bloggers](http://www.r-bloggers.com/).  The author Markus Gesmann is the maintainer of the `googleVis` package that links R to the [Google Charts API](https://developers.google.com/chart/interactive/docs/gallery).  My first thought was:  could I embed charts like those in R Markdown documents that could knit to ioslides or other formats suitable for use in my elementary statistics classes?

<!--more-->

A quick look at the documentation showed that it's very easy indeed to do this sort of thing.


## Extrapolation

Suppose, for example, that you want to illustrate to students the risks associated with extrapolation.  You begin by reminding them of the experience they had back in high school with their graphing calculators, when they zoomed in on a curve:  zoom in close enough, and it looks like a straight line.

Then you point out that for the most part we live our lives from a "zoomed-in" perspective, at least where data is concerned.  In situations where we are interested in a pair of numerical measurements on individuals, we usually possess $$ y $$-values for only a fairly narrow range of $$ x $$-values.  Hence it is likely that a scatter plot we make from our "zoomed-in" data will show a roughly linear relationship, even though on a global scale the "real" relationship probably is some kind of a curve.

The app below (a slight modification of the example in Gesmann's post) makes the point in a flash.  Click and drag to establish a zoom region, right-click to reset:


<!-- ScatterChart generated in R 3.2.2 by googleVis 0.5.10 package -->
<!-- Tue Dec 15 19:49:23 2015 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataZoomZoom () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 0,
2537.697212 
],
[
 0.5,
2480.404837 
],
[
 1,
2291.197683 
],
[
 1.5,
2239.20941 
],
[
 2,
2024.346568 
],
[
 2.5,
2328.30735 
],
[
 3,
2302.912102 
],
[
 3.5,
2139.312225 
],
[
 4,
2291.913135 
],
[
 4.5,
2081.986679 
],
[
 5,
1939.687718 
],
[
 5.5,
2071.175918 
],
[
 6,
2055.637296 
],
[
 6.5,
1855.09161 
],
[
 7,
1836.673977 
],
[
 7.5,
1986.254312 
],
[
 8,
1934.399588 
],
[
 8.5,
1418.373539 
],
[
 9,
1452.102505 
],
[
 9.5,
1646.080349 
],
[
 10,
1817.436525 
],
[
 10.5,
1670.068265 
],
[
 11,
1552.822032 
],
[
 11.5,
1474.935244 
],
[
 12,
1527.426874 
],
[
 12.5,
1426.125064 
],
[
 13,
1498.784138 
],
[
 13.5,
1425.921831 
],
[
 14,
1281.256681 
],
[
 14.5,
1271.293199 
],
[
 15,
1143.749534 
],
[
 15.5,
1115.879783 
],
[
 16,
1265.534507 
],
[
 16.5,
1365.787371 
],
[
 17,
1127.811847 
],
[
 17.5,
1085.312767 
],
[
 18,
995.4401713 
],
[
 18.5,
999.8514718 
],
[
 19,
904.9701396 
],
[
 19.5,
974.9688372 
],
[
 20,
990.8501134 
],
[
 20.5,
819.7440402 
],
[
 21,
810.8995988 
],
[
 21.5,
739.6464023 
],
[
 22,
665.9922973 
],
[
 22.5,
781.5574713 
],
[
 23,
691.9288703 
],
[
 23.5,
704.4679564 
],
[
 24,
742.0044122 
],
[
 24.5,
699.1293635 
],
[
 25,
606.1210083 
],
[
 25.5,
660.3859521 
],
[
 26,
508.6239947 
],
[
 26.5,
599.8550241 
],
[
 27,
540.8753228 
],
[
 27.5,
518.3726283 
],
[
 28,
465.3953206 
],
[
 28.5,
329.4228811 
],
[
 29,
384.3077049 
],
[
 29.5,
478.1333933 
],
[
 30,
590.9037231 
],
[
 30.5,
405.3257043 
],
[
 31,
201.1684941 
],
[
 31.5,
662.4131747 
],
[
 32,
419.5235375 
],
[
 32.5,
343.1144616 
],
[
 33,
381.2919068 
],
[
 33.5,
251.6978654 
],
[
 34,
265.2966701 
],
[
 34.5,
257.076218 
],
[
 35,
304.5839125 
],
[
 35.5,
374.8505607 
],
[
 36,
24.30756836 
],
[
 36.5,
150.4156894 
],
[
 37,
78.5860028 
],
[
 37.5,
85.85072033 
],
[
 38,
-33.80994618 
],
[
 38.5,
60.02448374 
],
[
 39,
125.615421 
],
[
 39.5,
134.6158021 
],
[
 40,
162.8331306 
],
[
 40.5,
87.78614177 
],
[
 41,
312.4153309 
],
[
 41.5,
89.97102573 
],
[
 42,
-38.44147667 
],
[
 42.5,
283.7181301 
],
[
 43,
-139.9056665 
],
[
 43.5,
151.6451601 
],
[
 44,
220.6167027 
],
[
 44.5,
82.35326735 
],
[
 45,
-128.2962108 
],
[
 45.5,
-173.6864969 
],
[
 46,
64.69165381 
],
[
 46.5,
136.7736691 
],
[
 47,
-12.72734263 
],
[
 47.5,
-71.70931145 
],
[
 48,
38.88744997 
],
[
 48.5,
70.422425 
],
[
 49,
-52.14613874 
],
[
 49.5,
-67.48934215 
],
[
 50,
-172.8783941 
],
[
 50.5,
-98.87609916 
],
[
 51,
-57.55055617 
],
[
 51.5,
40.6021748 
],
[
 52,
78.66649197 
],
[
 52.5,
-86.59209118 
],
[
 53,
-24.81762967 
],
[
 53.5,
166.7614015 
],
[
 54,
42.65088778 
],
[
 54.5,
50.20339324 
],
[
 55,
-7.280201955 
],
[
 55.5,
173.7847433 
],
[
 56,
136.6527204 
],
[
 56.5,
-129.6913636 
],
[
 57,
78.89204617 
],
[
 57.5,
-26.2225636 
],
[
 58,
-55.95898328 
],
[
 58.5,
-55.38871173 
],
[
 59,
68.68219333 
],
[
 59.5,
306.8442199 
],
[
 60,
68.77170251 
],
[
 60.5,
146.9939225 
],
[
 61,
247.9439261 
],
[
 61.5,
-94.23538391 
],
[
 62,
15.01500904 
],
[
 62.5,
175.0385938 
],
[
 63,
244.1642855 
],
[
 63.5,
360.7181336 
],
[
 64,
346.8271736 
],
[
 64.5,
114.9338291 
],
[
 65,
235.342274 
],
[
 65.5,
179.6939502 
],
[
 66,
246.2399374 
],
[
 66.5,
259.9051893 
],
[
 67,
184.5320483 
],
[
 67.5,
298.762966 
],
[
 68,
500.0135333 
],
[
 68.5,
199.0380413 
],
[
 69,
627.2201028 
],
[
 69.5,
251.1308468 
],
[
 70,
401.5101774 
],
[
 70.5,
416.2819428 
],
[
 71,
660.1440323 
],
[
 71.5,
264.606245 
],
[
 72,
530.3665665 
],
[
 72.5,
480.0287843 
],
[
 73,
415.4285494 
],
[
 73.5,
573.3799481 
],
[
 74,
585.9427928 
],
[
 74.5,
294.5816348 
],
[
 75,
590.2863346 
],
[
 75.5,
455.5873842 
],
[
 76,
654.3923354 
],
[
 76.5,
557.3303521 
],
[
 77,
763.5434061 
],
[
 77.5,
775.0702394 
],
[
 78,
671.2147217 
],
[
 78.5,
817.2950343 
],
[
 79,
772.7300908 
],
[
 79.5,
935.0553817 
],
[
 80,
961.0364487 
],
[
 80.5,
878.9843067 
],
[
 81,
1036.440589 
],
[
 81.5,
1011.060497 
],
[
 82,
831.1714369 
],
[
 82.5,
1179.832136 
],
[
 83,
1121.827731 
],
[
 83.5,
1036.758551 
],
[
 84,
966.4311784 
],
[
 84.5,
1274.919241 
],
[
 85,
1349.402511 
],
[
 85.5,
1283.875996 
],
[
 86,
1219.930646 
],
[
 86.5,
1409.472096 
],
[
 87,
1435.155675 
],
[
 87.5,
1246.876663 
],
[
 88,
1224.965309 
],
[
 88.5,
1364.574604 
],
[
 89,
1626.000513 
],
[
 89.5,
1559.679692 
],
[
 90,
1572.398767 
],
[
 90.5,
1725.102129 
],
[
 91,
1576.106534 
],
[
 91.5,
1548.891366 
],
[
 92,
2005.413909 
],
[
 92.5,
1786.685823 
],
[
 93,
1941.678696 
],
[
 93.5,
1820.903637 
],
[
 94,
1806.025829 
],
[
 94.5,
2068.67964 
],
[
 95,
2145.064152 
],
[
 95.5,
1953.216022 
],
[
 96,
2192.147189 
],
[
 96.5,
2249.259024 
],
[
 97,
2136.275729 
],
[
 97.5,
2318.912073 
],
[
 98,
2194.855727 
],
[
 98.5,
2300.640547 
],
[
 99,
2402.693396 
],
[
 99.5,
2516.349069 
],
[
 100,
2427.046688 
] 
];
data.addColumn('number','x');
data.addColumn('number','y');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartZoomZoom() {
var data = gvisDataZoomZoom();
var options = {};
options["allowHtml"] = true;
options["explorer"] = {actions: ['dragToZoom',
                     'rightClickToReset'],
                     maxZoomIn:0.05};
options["chartArea"] = {width:'85%',height:'80%'};
options["hAxis"] = {title: 'Explanatory x',
                     titleTextStyle: {color: '#000000'}};
options["vAxis"] = {title: 'Response y',
                     titleTextStyle: {color: '#000000'}};
options["title"] = "Curvilinear Relationship";
options["width"] =    550;
options["height"] =    500;
options["legend"] = "none";

    var chart = new google.visualization.ScatterChart(
    document.getElementById('ZoomZoom')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartZoomZoom);
})();
function displayChartZoomZoom() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartZoomZoom"></script>
 
<!-- divChart -->
  
<div id="ZoomZoom" 
  style="width: 550; height: 500;">
</div>

All we needed was the following code (be sure to add the chunk option `results='asis'`):


{% highlight r %}
set.seed(2020)
x <- seq(0,100,by=0.5)
y <- (50-x)^2+rnorm(length(x),sd=100)

curvy <- data.frame(x,y)


gvScat <- gvisScatterChart(curvy,
                   options=list(
                     explorer="{actions: ['dragToZoom',
                     'rightClickToReset'],
                     maxZoomIn:0.05}",
                     chartArea="{width:'85%',height:'80%'}",
                     hAxis="{title: 'Explanatory x',
                     titleTextStyle: {color: '#000000'}}",
                     vAxis="{title: 'Response y',
                     titleTextStyle: {color: '#000000'}}",
                     title="Curvilinear Relationship",
                     width=550, height=500,
                     legend="none"),
                   chartid="ZoomZoom")

print(gvScat,'chart')
{% endhighlight %}


The same approach works in any R Markdown document (including the source document for this Jekyll-powered post).  I will certainly take a closer look at `googleVis`:  thanks, Markus!


