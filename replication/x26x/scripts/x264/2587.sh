#!/bin/sh

numb='2588'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 15 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.5,1.3,3.2,0.3,0.9,0.9,3,0,2,15,200,0,30,0,4,1,61,38,5,1000,1:1,dia,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"