#!/bin/sh

numb='1736'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 30 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.3,3.2,0.5,0.9,0.3,1,1,6,30,300,0,30,20,4,0,67,28,2,1000,-2:-2,hex,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"