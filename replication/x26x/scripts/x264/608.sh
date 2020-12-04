#!/bin/sh

numb='609'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 40 --keyint 200 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.0,3.6,0.5,0.7,0.8,2,0,2,40,200,1,23,10,4,4,64,38,2,1000,-2:-2,hex,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"