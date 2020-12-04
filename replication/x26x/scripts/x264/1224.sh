#!/bin/sh

numb='1225'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.0,1.0,3.0,0.2,0.6,0.9,0,2,6,10,230,4,29,0,4,0,66,38,2,1000,-2:-2,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"