#!/bin/sh

numb='1493'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.0,1.4,1.6,0.2,0.7,0.2,3,0,2,40,270,0,22,30,4,0,66,48,5,1000,-1:-1,umh,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"