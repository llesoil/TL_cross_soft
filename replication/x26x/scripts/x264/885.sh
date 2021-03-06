#!/bin/sh

numb='886'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 50 --keyint 270 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.3,0.8,0.2,0.6,0.4,1,0,4,50,270,2,21,0,3,3,66,28,5,2000,-2:-2,dia,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"