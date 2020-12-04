#!/bin/sh

numb='46'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.3,3.0,0.3,0.7,0.1,2,2,0,30,300,4,22,30,5,0,67,18,1,2000,-2:-2,hex,crop,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"