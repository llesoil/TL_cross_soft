#!/bin/sh

numb='1379'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 30 --keyint 290 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.4,1.0,0.8,0.3,0.9,0.9,1,0,16,30,290,0,22,30,5,3,69,38,6,1000,-2:-2,umh,show,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"