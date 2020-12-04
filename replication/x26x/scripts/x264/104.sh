#!/bin/sh

numb='105'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 10 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.0,1.3,3.4,0.3,0.6,0.2,3,0,8,10,220,2,20,0,4,0,68,48,1,1000,-2:-2,umh,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"