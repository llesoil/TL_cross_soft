#!/bin/sh

numb='257'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 15 --keyint 260 --lookahead-threads 3 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.2,3.8,0.3,0.8,0.5,1,1,10,15,260,3,27,30,5,4,67,18,6,2000,1:1,hex,crop,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"