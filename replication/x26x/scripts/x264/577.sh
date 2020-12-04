#!/bin/sh

numb='578'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.2,4.2,0.5,0.7,0.3,3,1,14,5,210,3,20,0,5,1,61,18,5,1000,-2:-2,hex,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"