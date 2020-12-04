#!/bin/sh

numb='1022'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.2,1.1,4.8,0.3,0.6,0.7,0,1,12,0,210,3,24,10,3,0,68,18,2,2000,-2:-2,dia,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"