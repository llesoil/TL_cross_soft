#!/bin/sh

numb='464'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 25 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.1,1.8,0.5,0.6,0.5,0,0,10,25,220,4,29,0,5,3,67,18,1,1000,1:1,dia,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"