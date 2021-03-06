#!/bin/sh

numb='1585'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 25 --keyint 290 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.3,1.1,0.4,0.6,0.6,0.2,3,0,12,25,290,3,25,50,4,1,62,28,4,1000,-2:-2,hex,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"