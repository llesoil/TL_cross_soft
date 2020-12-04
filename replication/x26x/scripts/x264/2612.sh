#!/bin/sh

numb='2613'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 25 --keyint 290 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.4,1.3,0.6,0.4,0.7,0.2,1,2,16,25,290,2,22,0,3,3,62,48,3,1000,-1:-1,hex,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"