#!/bin/sh

numb='2579'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.3,0.8,0.3,0.9,0.0,3,2,10,45,220,2,22,20,5,4,60,38,3,1000,-2:-2,umh,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"