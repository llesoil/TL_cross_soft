#!/bin/sh

numb='1775'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.5,1.3,3.2,0.5,0.9,0.2,3,2,10,0,270,2,30,40,5,4,67,48,1,1000,-1:-1,hex,show,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"