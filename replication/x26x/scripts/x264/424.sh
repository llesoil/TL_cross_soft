#!/bin/sh

numb='425'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.4,1.3,2.2,0.6,0.9,0.9,2,2,8,25,230,1,24,40,4,3,63,28,2,2000,-2:-2,hex,crop,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"