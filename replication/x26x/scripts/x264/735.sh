#!/bin/sh

numb='736'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 30 --keyint 290 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.6,1.2,1.6,0.4,0.7,0.9,0,0,8,30,290,3,29,20,4,3,61,28,2,2000,-2:-2,dia,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"