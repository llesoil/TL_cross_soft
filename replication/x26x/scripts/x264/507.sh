#!/bin/sh

numb='508'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 0 --keyint 250 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.0,3.4,0.5,0.7,0.3,1,0,4,0,250,1,27,10,4,0,69,28,1,2000,-1:-1,umh,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"